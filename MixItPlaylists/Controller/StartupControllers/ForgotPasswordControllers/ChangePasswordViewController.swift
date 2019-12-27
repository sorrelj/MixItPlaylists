//
//  ChangePasswordViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/12/19.
//  Copyright © 2019 MixIt. All rights reserved.
//


import Foundation
import Combine
import SwiftUI

import CryptoKit

// MARK: Sign up Response Struct

// Struct to send /login response to the view
struct ChangePasswordResponse: Decodable {
    
    // track when the user has been created
    var success: Bool
    
    // error message if error
    var message: String
    
    // init the struct
    init (success: Bool, message: String) {
        self.success = success
        self.message = message
    }

}

// MARK: Forgot Password View Controller

final class ChangePasswordViewController: ObservableObject {
    
    // Sign up user
    func changePassword(username: String, code: String, password:String, callback: @escaping (ChangePasswordResponse)->() ) {
                
        // sha256 the password
        let passData = Data(password.utf8)
        var hash = SHA256.hash(data: passData).description
        hash = hash.replacingOccurrences(of: "SHA256 digest: ", with: "")
        
        // set the request
        let change = APIRequest(requestType: .POST, name: .changePassword, params: ["username": username, "newPassword": hash.description, "code": code])
        
        
        // perform the api network call
        APINetworkController().apiNetworkRequest(req: change, callback: { resp in
            print(resp)
            
            // No errors user is authorized
            if (resp.statusCode == 200){
                // set the signup return object
                let r = ChangePasswordResponse(
                    success: true,
                    message: ""
                )
                
                // send callback
                return callback(r)
                
            // Error
            }else{
                // set the signup return object
                let r = ChangePasswordResponse(
                    success: false,
                    message: resp.body["message"] as! String
                )
                
                // send callback
                return callback(r)
                
            }
        })
    }
    

    
    
}

