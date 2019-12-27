//
//  LogoutViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation



// MARK: Logout View Controller

final class LogoutViewController: ObservableObject {

    let keychainController = KeychainController()
    
    // login user function
    func logout(callback: @escaping (Bool)->() ) {
        // remove the access token from keychain
        keychainController.removeKeychainItem(tag: KeychainTags.AUTH.rawValue, key: "", callback: {res in
            if (res.status == .SUCCESS){
                return callback(true)
            }else {
                return callback(false)
            }
        })
        
    }

}
