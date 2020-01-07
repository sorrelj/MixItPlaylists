//
//  SpotifyAuthController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/15/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import CryptoKit

// MARK: Spotify auth repsonse struct

// Struct to send /createplaylist response to the view
struct SpotifyAuthResponse: Decodable {

    // tracks user authed from spotify
    var authed: Bool

    // access token
    var accessToken: String
    
    // refresh token
    var refreshToken: String
    
    // expire time from now
    var expireTime: Int
    
    // error msg
    var errorMsg: String
    
    // init with error
    init(authed:Bool, errorMsg: String){
        self.authed = authed
        self.errorMsg = errorMsg
        self.accessToken = ""
        self.refreshToken = ""
        self.expireTime = 0
    }
    
    // init success
    init(authed:Bool, accessToken: String, refreshToken: String, expireTime: Int){
        self.authed = authed
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expireTime = expireTime
        self.errorMsg = ""
    }
}

enum SpotifyAuthType: String {
    case
        swap = "swap",
        refresh = "refresh"
}

// MARK: Create Playlist View Controller

final class SpotifyAuthController: ObservableObject {
    
    // auth
    func authUser(type: SpotifyAuthType, code: String, callback: @escaping (SpotifyAuthResponse)->() ) {
                
        // set the request
        let auth = APIRequest(requestType: .POST, name: .spotifyAuth, params: ["type": type.rawValue, "token": code])
        
        // perform api network call
        APINetworkController().apiNetworkRequest(req: auth, callback: { resp in
            print(resp)
            
            // No errors user is authorized
            if (resp.statusCode == 200){
                // get the access token
                guard let accessToken = resp.body["access_token"] as? String else {
                    let spotResp = SpotifyAuthResponse(authed: false, errorMsg: "unknown error")
                    return callback(spotResp)
                }
                
                // get the refresh token if needed
                var refreshToken = ""
                if type == .swap {
                    guard let refresh = resp.body["refresh_token"] as? String else {
                        let spotResp = SpotifyAuthResponse(authed: false, errorMsg: "unknown error")
                        return callback(spotResp)
                    }
                    refreshToken = refresh
                }
                
                // get exipre time
                guard let expiresIn = resp.body["expires_in"] as? Int else {
                    let spotResp = SpotifyAuthResponse(authed: false, errorMsg: "unknown error")
                    return callback(spotResp)
                }
                
                // return callback
                return callback(SpotifyAuthResponse(authed: true, accessToken: accessToken, refreshToken: refreshToken, expireTime: expiresIn))
            
            }else{
                // response
                var spotResp: SpotifyAuthResponse
                
                // find error
                if let errorDesc = resp.body["error_description"] as? String {
                    spotResp = SpotifyAuthResponse(authed: false, errorMsg: errorDesc)
                }else if let error = resp.body["error"] as? String {
                    spotResp = SpotifyAuthResponse(authed: false, errorMsg:error)
                }else if let errorMessage = resp.body["message"] as? String {
                    spotResp = SpotifyAuthResponse(authed: false, errorMsg: errorMessage)
                }else{
                    spotResp = SpotifyAuthResponse(authed: false, errorMsg: "unknown error")
                }
                
                callback(spotResp)
            }
        })
    }
}

