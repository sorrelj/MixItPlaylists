//
//  KeychainModel.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/26/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation

enum KeychainTags: String {
    case
        AUTH = "com.mixitplaylists.key.authToken",
        TEST = "com.mixitplaylists.key.test"
}


struct StoreKeychainStatus {
    // error / success
    enum StoreKeychainStatusType: String {
        case
            SUCCESS,
            REMOVE_OLD_ERROR,
            KEYCHAIN_KEY_ERROR,
            KEYCHAIN_TAG_ERROR,
            SET_QUERY_ERROR,
            STORE_QUERY_ERROR,
            UNKNOWN_ERROR
    }
    
    // status
    let status: StoreKeychainStatusType
    
    init (status: StoreKeychainStatusType){
        self.status = status
    }
}

struct GetKeychainStatus {
    // error / success
    enum GetKeychainStatusType: String {
        case
            SUCCESS,
            KEYCHAIN_TAG_ERROR,
            GET_QUERY_ERROR,
            KEY_TO_STRING_ERROR,
            UNKNOWN_ERROR
    }
    
    // status
    let status: GetKeychainStatusType
    
    // key
    let key: String
    
    init(status: GetKeychainStatusType) {
        self.status = status
        self.key = ""
    }
    
    init(status: GetKeychainStatusType, key: String){
        self.status = status
        self.key = key
    }
}
