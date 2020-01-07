//
//  GetUserImage.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 1/4/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import Foundation


final class GetUserImage {
    
    // get user image
    func getUserImage(imageID: String, callback: @escaping (UIImage)->()) {
        // set request
        let req = SpotifyAPIRequest(requestType: .GET, rawName: "artists/"+imageID, params: [:], expectedResponse: .nothing)
        
        // send request
        DispatchQueue.main.async {
            SpotifyWebAPIController().spotifyWebAPIRequest(req: req, callback: { resp in
                // check for errir
                if resp.error{
                    return callback(UIImage())
                }else{
                    // get and load image
                    
                    // get image array
                    guard let images = resp.dataObject["images"] as? [[String: Any]] else {
                        print("GET IMAGE - images error")
                        return
                    }
                    
                    // get first url
                    guard let url = images[0]["url"] as? String else {
                        print("GET IMAGE - image url error")
                        return
                    }
                    
                    // get image from url
                    let imgData = NSData(contentsOf: URL(string: url)!)
                    let uiImage = UIImage(data: imgData! as Data)!
                    
                    
                    return callback(uiImage)
                }
            })
        }
    }

}
