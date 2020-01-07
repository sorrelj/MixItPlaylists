//
//  APINetworkController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 10/3/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation

class APINetworkController {
    
    func apiNetworkRequest(req: APIRequest, callback: @escaping (APIResponse)->()) {
        
        //call HTTP request
        
        //set the parameters
        let params = req.parameters
                
        //generate the url string
        let uStr = "https://msi8hgaqr6.execute-api.us-east-2.amazonaws.com/default/" + req.requestURL
        
        //create the url object
        let url = URL(string: uStr)!
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = req.requestType //set http method
        
        if req.requestType == "POST" {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
        }else{
            for (key, value) in params {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.addValue("otT7gBa6PHdQ6oyiwpmz3YiPZRJ9kVg7Vm1xvtgg", forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        // add token header if needed
        if req.withToken {
            let scene = UIApplication.shared.connectedScenes.first
            guard let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) else {
                print("Get scene error")
                return
            }
                
            // get token
            guard let mixItToken = sd.mixItToken else {
                print("Get spotify access token error")
                return
            }
                
            // check for empty access token
            if (mixItToken.isEmpty) {
                print("NO ACCESS TOKEN")
                return
            }
            
            request.addValue(mixItToken, forHTTPHeaderField: "token")
        }
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // if error
            guard error == nil else {
                print("ERROR (" + req.requestURL + ") ", error)
                // send error
                return callback(APIResponse(status: 500, responseBody: ["message": "A connection error occured. Please try again."], header: [:]))
            }
            
            // if data cannot be gathered
            guard let data = data else {
                return
            }
            
            // get the httpResponse
            guard let httpResponse = response as? HTTPURLResponse else{
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    guard let status = json["statusCode"] as? Int else{
                        print("ERROR - status code")
                        print(json)
                        print(httpResponse.statusCode)
                        return
                    }
                    
                    guard let body = json["body"] as? [String: Any] else{
                        print("ERROR - body")
                        print(json)
                        return
                    }
                    
                    
                    // setup the response object
                    let response = APIResponse(
                                    status: status,
                                    responseBody: body,
                                    header: httpResponse.allHeaderFields
                                )
                
                    
                    //handle repsonse
                    callback(response)
                    
                }
            } catch let error {
                print(req.requestURL,error.localizedDescription)
            }
        })
        task.resume()
        
        
        
    }
    
}
