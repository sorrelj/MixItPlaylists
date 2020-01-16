//
//  SpotifyWebAPIController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation

class SpotifyWebAPIController {
    
    private var accessTok: String = ""
    
    func spotifyWebAPIRequest(req: SpotifyAPIRequest, callback: @escaping (SpotifyAPIResponse)->()) {
        
        //call HTTP request
        
        //set the parameters
        let params = req.parameters
                
        //generate the url string
        var uStr = "https://api.spotify.com/v1/"
        
        // check if url is already formed
        if !req.requestURL.starts(with: uStr) {
            // append url to end
            uStr.append(contentsOf: req.requestURL)
        }else{
            // set the whole url
            uStr = req.requestURL
        }
        
        
        
        // Begin setting http request
        var request: URLRequest
        
        if req.requestType == "GET" {
            if params.count > 0 {
                //create the url object
                var urlComps = URLComponents(string: uStr)!
                
                let stringParams = params as! [String: String]
                
                // set query params
                urlComps.queryItems = stringParams.map { (key, value) in
                    URLQueryItem(name: key, value: value)
                }
                urlComps.percentEncodedQuery = urlComps.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
                
                
                //now create the URLRequest object using the url object
                request = URLRequest(url: urlComps.url!)
            }else{
                request = URLRequest(url: URL(string: uStr)!)
            }
            
            request.httpMethod = req.requestType //set http method
        // PUT / POST
        }else{
            request = URLRequest(url: URL(string: uStr)!)
            request.httpMethod = req.requestType
            
            if req.imgHeader {
                request.httpBody = req.customParams[0].data(using: .utf8)
            }else{
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
                
        // get the spotify auth token
        var bearer = "Bearer "
        if accessTok.isEmpty {
            let scene = UIApplication.shared.connectedScenes.first
            guard let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) else {
                print("Get scene error")
                return
            }
                
            // get token
            guard let accessToken = sd.accessToken else {
                print("Get spotify access token error")
                return
            }
                
            // check for empty access token
            if (accessToken.isEmpty) {
                print("NO ACCESS TOKEN")
                return
            }
                
            self.accessTok = accessToken
            bearer = bearer + accessToken
        }else{
            bearer = bearer + accessTok
        }
        
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
            
        if (req.imgHeader){
            request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        }else{
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
         
        
        //create the session object
        let session = URLSession.shared
    
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // if error
            guard error == nil else {
                print("ERROR (" + req.requestURL + ") ", error)
                return
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
                    if (httpResponse.statusCode - 210) > 0 {
                        // error occures
                        let resp = SpotifyAPIResponse(error: true, data: json)
                        
                        // return callback
                        return callback(resp)
                    }
                    
                    if req.responseObjectName ==  SpotifyAPIRequest.expectedResponse.nothing.rawValue {
                        let resp = SpotifyAPIResponse(dataObject: json)
                        return callback(resp)
                    }else if let spotifyData = json[req.responseObjectName] as? [Any] {
                        let resp = SpotifyAPIResponse(dataArray: spotifyData)
                        return callback(resp)
                    }else{
                        // get the error message
                        guard let err = json["error"] as? [String: Any] else{
                            print("Error: getting spotify error", json)
                            return
                        }
                        
                        // check for status code 401
                        
                        let resp = SpotifyAPIResponse(error: true, data: err)
                        
                        // return callback
                        return callback(resp)
                    }
                }
            } catch let error {
                print(req.requestURL,error.localizedDescription)
                return callback(SpotifyAPIResponse())
            }
        })
        task.resume()
        

        
    }
    
}
