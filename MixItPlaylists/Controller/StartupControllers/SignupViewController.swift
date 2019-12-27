//
//  SignupViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/17/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import CryptoKit

// MARK: Sign up Response Struct

// Struct to send /login response to the view
struct SignupResponse: Decodable {
    
    // track when the user has been created
    var userCreated: Bool
    
    // error message if error
    var message: String
    
    // init the struct
    init (userCreated: Bool, message: String) {
        self.userCreated = userCreated
        self.message = message
    }

}

// MARK: Sign Up View Controller

final class SignupViewController: ObservableObject {
    
    // Sign up user
    func signupUser(number: String, username: String, password: String, callback: @escaping (SignupResponse)->() ) {
        
        // sha256 the password
        let passData = Data(password.utf8)
        var hash = SHA256.hash(data: passData).description
        hash = hash.replacingOccurrences(of: "SHA256 digest: ", with: "")
                
        // set the request
        let register = APIRequest(requestType: .POST, name: .register, params: ["number": number, "username": username, "password": hash.description])
        
        
        // perform the api network call
        APINetworkController().apiNetworkRequest(req: register, callback: { resp in
            print(resp)
            
            // No errors user is authorized
            if (resp.statusCode == 200){
                // set the signup return object
                let resSignup = SignupResponse(
                    userCreated: true,
                    message: ""
                )
                
                // send callback
                return callback(resSignup)
                
            // Error
            }else{
                // set the signup return object
                let resSignup = SignupResponse(
                    userCreated: false,
                    message: resp.body["message"] as! String
                )
                
                // send callback
                return callback(resSignup)
                
            }
        })
    }
    

    
    
}

