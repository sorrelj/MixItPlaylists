//
//  APIResponse.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/3/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
struct APIResponse {
    
    // status code
    var statusCode: Int
    
    // response body
    var body: [String: Any]

    // response headers
    var headers: [AnyHashable: Any]
    
    init(status: Int, responseBody: [String:Any], header: [AnyHashable: Any]){
        self.statusCode = status
        self.body = responseBody
        self.headers = header
    }
    
}

