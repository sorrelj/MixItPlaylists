//
//  ForgotPasswordViewController.swift
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
struct ForgotPasswordResponse: Decodable {
    
    // track when the user has been created
    var codeSent: Bool
    
    // error message if error
    var message: String
    
    // init the struct
    init (codeSent: Bool, message: String) {
        self.codeSent = codeSent
        self.message = message
    }

}

// MARK: Forgot Password View Controller

final class ForgotPasswordViewController: ObservableObject {
    
    // Sign up user
    func forgotPassword(number: String, callback: @escaping (ForgotPasswordResponse)->() ) {
                
        // set the request
        let forgot = APIRequest(requestType: .POST, name: .forgot, params: ["number": number])
        
        
        // perform the api network call
        APINetworkController().apiNetworkRequest(req: forgot, callback: { resp in
            print(resp)
            
            // No errors user is authorized
            if (resp.statusCode == 200){
                // set the signup return object
                let r = ForgotPasswordResponse(
                    codeSent: true,
                    message: ""
                )
                
                // send callback
                return callback(r)
                
            // Error
            }else{
                // set the signup return object
                let r = ForgotPasswordResponse(
                    codeSent: false,
                    message: resp.body["message"] as! String
                )
                
                // send callback
                return callback(r)
                
            }
        })
    }
    

    
    
}

