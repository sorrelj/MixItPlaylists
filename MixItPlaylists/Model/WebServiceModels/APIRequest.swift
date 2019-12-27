//
//  APIRequest.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/3/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation


struct APIRequest {
    
    // request type
    enum httpRequest: String {
        case GET, POST
    }
    
    // type
    enum requestName: String {
        case
            login = "userlogin",
            register = "createAccount",
            forgot = "forgotpassword",
            changePassword = "changepassword",
            confirm = "confirmaccount",
            resendConfirm = "resendconfirm",
            confirmImage = "confirmimage",
            authUser = "authuser",
            spotifyAuth = "spotifyauth",
            createPlaylist = "createplaylist"
    }
    
    // request
    var requestType: String
    
    // url
    var requestURL: String
    
    // body / query params
    var parameters: [String: String]
    
    // with token
    var withToken: Bool
    
    init(requestType: httpRequest,
         name: requestName,
         params: [String: String]){
        
        self.requestType = requestType.rawValue
        self.requestURL = name.rawValue
        self.parameters = params
        
        self.withToken = false
        
    }
    
    init(requestType: httpRequest,
         name: requestName,
         params: [String: String],
         withToken: Bool){
        
        self.requestType = requestType.rawValue
        self.requestURL = name.rawValue
        self.parameters = params
        self.withToken = withToken
    }
    
    
}
