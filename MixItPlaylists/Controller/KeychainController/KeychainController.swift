//
//  KeychainController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/26/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

/*
 
 let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
 kSecAttrApplicationTag as String: tag,
 kSecValueRef as String: key]
 
 */


import Foundation

class KeychainController {
    
    /// MARK: Store Keychain Item
    
    func storeKeychainItem(key: String, tag: String, callback: @escaping (StoreKeychainStatus) -> ()) {

        // set the tag
        guard let kTag = tag.data(using: .utf8) else {
            return callback(StoreKeychainStatus(status: .KEYCHAIN_TAG_ERROR))
        }
        
        // set the key
        guard let kKey = key.data(using: .utf8) else {
            return callback(StoreKeychainStatus(status: .KEYCHAIN_KEY_ERROR))
        }
        
        // set the query to store
        let storeQuery: [String: Any] = [kSecClass as String: kSecClassKey, kSecAttrApplicationTag as String: kTag, kSecValueData as String: kKey]
        
        // remove old item if needed
        let removeStatus = SecItemDelete(storeQuery as CFDictionary)
        
        // read status
//        guard removeStatus == errSecSuccess else {
//            print(SecCopyErrorMessageString(removeStatus, nil))
//
//            // remove old query
//            return callback(StoreKeychainStatus(status: .REMOVE_OLD_ERROR))
//        }
                
        // store the item
        let status = SecItemAdd(storeQuery as CFDictionary, nil)
                
        // check the status
        guard status == errSecSuccess else {
            print(SecCopyErrorMessageString(status, nil))
            
            // error storing query
            return callback(StoreKeychainStatus(status: .STORE_QUERY_ERROR))
        }
        
        
        // return success
        return callback(StoreKeychainStatus(status: .SUCCESS))
    }
    
    /// MARK: Remove Keychain Item
    
    func removeKeychainItem(tag: String, key: String, callback: @escaping (StoreKeychainStatus) -> ()){
        // set the tag
        guard let kTag = tag.data(using: .utf8) else {
            return callback(StoreKeychainStatus(status: .KEYCHAIN_TAG_ERROR))
        }
        
        // set the key
        guard let kKey = key.data(using: .utf8) else {
            return callback(StoreKeychainStatus(status: .KEYCHAIN_KEY_ERROR))
        }
        
        // set the query to store
        let storeQuery: [String: Any] = [kSecClass as String: kSecClassKey, kSecAttrApplicationTag as String: kTag, kSecValueData as String: kKey]
        
        // remove old item if needed
        let removeStatus = SecItemDelete(storeQuery as CFDictionary)
        
        // read status
        guard removeStatus == errSecSuccess else {
            print("Remove:",SecCopyErrorMessageString(removeStatus, nil))
            
            // remove old query
            return callback(StoreKeychainStatus(status: .REMOVE_OLD_ERROR))
        }
        
        return callback(StoreKeychainStatus(status: .SUCCESS))
    }

    /// MARK: Get Keychain Item
    
    func getKeychainItem(tag: String, callback: @escaping (GetKeychainStatus) -> ()) {
        // set the tag
        guard let kTag = tag.data(using: .utf8) else {
            return callback(GetKeychainStatus(status: .KEYCHAIN_TAG_ERROR))
        }
        
        // set the query
        let getQuery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: kTag,
                                       //kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                       kSecReturnData as String: true]
                                        
    
        
        // set reference for return
        var key: CFTypeRef?
        
        // run the query
        let status = SecItemCopyMatching(getQuery as CFDictionary, &key)
        
        // check the status
        guard status == errSecSuccess else {
            print("GET:",SecCopyErrorMessageString(status, nil))
            
            // error storing query
            return callback(GetKeychainStatus(status: .GET_QUERY_ERROR))
        }
        
                
        // get the string
        guard let keyString = String(data: key as! Data, encoding: .utf8) else{
            return callback(GetKeychainStatus(status: .KEY_TO_STRING_ERROR))
        }
        
        return callback(GetKeychainStatus(status: .SUCCESS, key: keyString))
        
    }
    
}
