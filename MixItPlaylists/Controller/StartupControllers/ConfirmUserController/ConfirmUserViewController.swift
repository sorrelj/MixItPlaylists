//
//  ConfirmUserViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/18/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import CryptoKit

// MARK: Sign up Response Struct

// Struct to send /login response to the view
struct ConfirmUserResponse: Decodable {
    
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

// MARK: Confirm User View Controller

final class ConfirmUserViewController: ObservableObject {
    
    // Sign up user
    func confirmUser(number: String, code: String, callback: @escaping (ConfirmUserResponse)->() ) {
                
        // set the request
        let forgot = APIRequest(requestType: .POST, name: .confirm, params: ["number": number, "code": code])
        
        
        // perform the api network call
        APINetworkController().apiNetworkRequest(req: forgot, callback: { resp in
            print(resp)
            
            // No errors user is authorized
            if (resp.statusCode == 200){
                // set the signup return object
                let r = ConfirmUserResponse(
                    success: true,
                    message: ""
                )
                
                // send callback
                return callback(r)
                
            // Error
            }else{
                // set the signup return object
                let r = ConfirmUserResponse(
                    success: false,
                    message: resp.body["message"] as! String
                )
                
                // send callback
                return callback(r)
                
            }
        })
    }
    

    
    
}

