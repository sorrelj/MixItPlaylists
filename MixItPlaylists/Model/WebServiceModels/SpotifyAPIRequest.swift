//
//  SpotifyAPIRequest.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation

struct SpotifyAPIRequest {
    
    // request type
    enum httpRequest: String {
        case GET, POST, PUT
    }
    
    // request
    var requestType: String
    
    // type
    enum requestName: String {
        case
            getArtists = "me/top/artists",
            getMe = "me",
            search = "search"
        
    }
    
    // url
    var requestURL: String
    
    // body / query params
    var parameters: [String: String]
    var customParams: [String] = []
    
    enum expectedResponse: String {
        case
            items = "items",
            nothing = ""
    }
    
    // json repsonse object
    var responseObjectName: String
    
    // cutsom header
    var imgHeader: Bool = false
    
    init(requestType: httpRequest,
         name: requestName,
         params: [String: String],
         expectedResponse: expectedResponse){
        
        self.requestType = requestType.rawValue
        self.requestURL = name.rawValue
        self.parameters = params
        self.responseObjectName = expectedResponse.rawValue
    }
    
    init(requestType: httpRequest,
         rawName: String,
         params: [String: String],
         expectedResponse: expectedResponse){
        
        self.requestType = requestType.rawValue
        self.requestURL = rawName
        self.parameters = params
        self.responseObjectName = expectedResponse.rawValue
    }
    
    init(requestType: httpRequest,
         rawName: String,
         customParams: [String],
         expectedResponse: expectedResponse,
         imgHeader: Bool){
        
        self.requestType = requestType.rawValue
        self.requestURL = rawName
        self.customParams = customParams
        self.responseObjectName = expectedResponse.rawValue
        self.imgHeader = imgHeader
        
        self.parameters = [:]
    }
    
}
