//
//  SpotifyAPIResponse.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation

struct SpotifyAPIResponse {
    
    // error Bool
    var error: Bool
    
    var errorData: [String: Any]
    
    // response data array
    var dataArray: [Any]
    
    // repsonse data object
    var dataObject: [String: Any]

    // response headers
    //var headers: [AnyHashable: Any]
    
    init (error: Bool, data: [String: Any]) {
        self.error = error
        self.errorData = data
        self.dataArray = []
        self.dataObject = [:]
    }
    
    init(dataArray: [Any]){
        self.error = false
        self.dataArray = dataArray
        self.errorData = [:]
        self.dataObject = [:]
    }
    
    init(dataObject: [String: Any]){
        self.error = false
        self.dataArray = []
        self.errorData = [:]
        self.dataObject = dataObject
    }
    
    init(){
        self.error = false
        self.dataArray = []
        self.errorData = [:]
        self.dataObject = [:]
    }
}
