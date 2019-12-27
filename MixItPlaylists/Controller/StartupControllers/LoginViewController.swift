//
//  LoginViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/3/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import CryptoKit

// MARK: Login Response Struct

// response status
enum LoginStatus: String {
    case
        AUTHED,
        NOTCONFIRMED,
        ERROR
}

// Struct to send /login response to the view
struct LoginResponse {
    
    // status
    var status: LoginStatus
    
    // error message if error
    var message: String
        
    
    // init the struct
    init (status: LoginStatus, message: String) {
        self.status = status
        self.message = message
    }

}

// MARK: Login View Controller

final class LoginViewController: ObservableObject {

    
    // login user function
    func loginUser(username: String, password: String, callback: @escaping (LoginResponse)->() ) {
        // sha256 the password
        let passData = Data(password.utf8)
        var hash = SHA256.hash(data: passData).description
        hash = hash.replacingOccurrences(of: "SHA256 digest: ", with: "")
                
        // set the request
        let login = APIRequest(requestType: .POST, name: .login, params: ["username": username, "password": hash.description])
        
        // perform api network call
        APINetworkController().apiNetworkRequest(req: login, callback: { resp in
            print(resp)
            
            // No errors user is authorized
            if (resp.statusCode == 200){
                // Get the auth code
                guard let auth = resp.body["token"] as? String else {
                    print("parse token error")
                    return
                }
                
                // Store the auth code
                
                // init keyhchain controller class
                let keychain = KeychainController()
                
                // call store function
                keychain.storeKeychainItem(key: auth, tag: KeychainTags.AUTH.rawValue, callback: { res in
                    // check for error
                    if (res.status == .SUCCESS) {
                        // set the login res
                        let resLogin = LoginResponse(
                            status: .AUTHED,
                            message: ""
                        )

                        // send callback
                        return callback(resLogin)
                    }else{
                        print(res.status)
                    }
                })
            // need to confirm account error
            } else if (resp.statusCode == 409) {
                // set the login res
                let resLogin = LoginResponse(
                    status: .NOTCONFIRMED,
                    message: resp.body["message"] as! String
                )

                // send callback
                return callback(resLogin)
                
            // Error
            }else{
                // set the login res
                let resLogin = LoginResponse(
                    status: .ERROR,
                    message: resp.body["message"] as! String
                )
                
                // send callback
                return callback(resLogin)
                
            }
        })
    }
    

    
    
}
