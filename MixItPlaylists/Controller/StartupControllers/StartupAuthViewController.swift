//
//  StartupAuthViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/28/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


// MARK: Startup Auth View Controller


final class StartupAuthViewController: ObservableObject {
    
    // keychain controller
    private var keychainController = KeychainController()

    
    // Sign up user
    func authUser(callback: @escaping (Bool)->()) {
        
        // get the access token
        keychainController.getKeychainItem(tag: KeychainTags.AUTH.rawValue, callback: { res in
            // check status
            if (res.status == .SUCCESS) {
                // set the request
                let auth = APIRequest(requestType: .POST, name: .authUser, params: ["token": res.key])
                
                
                // perform the api network call
                APINetworkController().apiNetworkRequest(req: auth, callback: { resp in
                    // No errors user is authorized
                    if (resp.statusCode == 200){
                        // get user data
                        guard let userData = resp.body["user"] as? [String: String] else{
                            return callback(false)
                        }
                        
                        DispatchQueue.main.async {
                            let scene = UIApplication.shared.connectedScenes.first
                            guard let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) else {
                                print("Get scene error")
                                return
                            }
                            
                            // set token
                            sd.mixItToken = res.key
                            
                            // set user data
                            sd.userData =   UserDataModel(username: userData["username"]!,imageID: userData["imageID"]!,number: userData["number"]!)
                        }

                        // send callback
                        return callback(true)
                    }else{
                        // send callback
                        return callback(false)
                    }
                })
            }else{
                // send callback
                return callback(false)
            }
        })
    }
    

    
    
}

