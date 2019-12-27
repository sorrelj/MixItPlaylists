//
//  ConfirmUserImageViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/20/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import CryptoKit

// MARK: Resend Confirm Response Struct

// Struct to send /login response to the view
struct ConfirmUserImageResponse: Decodable {
    
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

// MARK:  Confirmation Image View Controller

final class ConfirmUserImageViewController: ObservableObject {

    // Send profile image
    
    func confirmImage(number: String, id: String, callback: @escaping (ConfirmUserImageResponse)->() ) {
                
        // set the request
        let resend = APIRequest(requestType: .POST, name: .confirmImage, params: ["number": number, "imageID": id])
        
        
        // perform the api network call
        APINetworkController().apiNetworkRequest(req: resend, callback: { resp in
            print(resp)
            
            // No errors user is authorized
            if (resp.statusCode == 200){
                // set the confirm return object
                let r = ConfirmUserImageResponse(
                    success: true,
                    message: ""
                )
                
                // send callback
                return callback(r)
                
            // Error
            }else{
                // set the confirm return object
                let r = ConfirmUserImageResponse(
                    success: false,
                    message: resp.body["message"] as! String
                )
                
                // send callback
                return callback(r)
                
            }
        })
        
    }
    

    
    
}

