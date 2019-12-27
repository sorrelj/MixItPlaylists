//
//  ResendConfirmationCodeController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/18/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import CryptoKit

// MARK: Resend Confirm Response Struct

// Struct to send /login response to the view
struct ResendConfirmResponse: Decodable {
    
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

// MARK: Resend Confirmation Code View Controller

final class ResendConfirmationCodeViewController: ObservableObject {
    
    // Sign up user
    func resendCode(number: String, callback: @escaping (ResendConfirmResponse)->() ) {
                
        // set the request
        let resend = APIRequest(requestType: .POST, name: .resendConfirm, params: ["number": number])
        
        
        // perform the api network call
        APINetworkController().apiNetworkRequest(req: resend, callback: { resp in
            print(resp)
            
            // No errors user is authorized
            if (resp.statusCode == 200){
                // set the signup return object
                let r = ResendConfirmResponse(
                    success: true,
                    message: ""
                )
                
                // send callback
                return callback(r)
                
            // Error
            }else{
                // set the signup return object
                let r = ResendConfirmResponse(
                    success: false,
                    message: resp.body["message"] as! String
                )
                
                // send callback
                return callback(r)
                
            }
        })
    }
    

    
    
}

