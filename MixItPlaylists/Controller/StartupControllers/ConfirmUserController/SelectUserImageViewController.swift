//
//  SelectUserImageViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

import CryptoKit

// MARK: Resend Confirm Response Struct

// Struct to send /login response to the view
//struct SelectUserImageResponse: Decodable {
//
//    // track when the user has been created
//    var success: Bool
//
//    // error message if error
//    var message: String
//
//    // init the struct
//    init (success: Bool, message: String) {
//        self.success = success
//        self.message = message
//    }
//
//}

// MARK: Resend Confirmation Code View Controller

final class SelectUserImageViewController: ObservableObject {
    
    @Published var artists: [SpotifyArtistModel] = []
    
    private var tempArtists = [SpotifyArtistModel]()
    
    // Dispatch Queues
    var artistData_DispatchQueue = DispatchQueue(label: "artistData-queue")
    
//    @Binding var showActivityIndicator: Bool
//
//    init(actIndicator: Binding<Bool>) {
//        self._showActivityIndicator = actIndicator
//
//        self.getInitArtists()
//    }
    
    init() {
        self.getInitArtists()
    }
    
    // get initial artists
    func getInitArtists() {
        print("Get artists")
        
        self.tempArtists.removeAll()
  
        // set request
        let req = SpotifyAPIRequest(requestType: .GET, name: .getArtists, params: ["limit": "20"], expectedResponse: .items)
        
        SpotifyWebAPIController().spotifyWebAPIRequest(req: req, callback: { resp in
            if (resp.error) {
                // handle error
                print(resp.error, resp.errorData)
            }else{
                
                if (resp.dataArray.count > 0) {
                    self.parseItems(items: resp.dataArray)
                }else{
                    DispatchQueue.main.async {
                        self.getAArtists()
                    }
                }
                
            }
            
        })
    }
    
    private func getAArtists() {
        //DispatchQueue.main.async {
            // set request
            let req = SpotifyAPIRequest(requestType: .GET, name: .search, params: ["limit": "20", "market": "US", "type": "artist", "q": "A"], expectedResponse: .nothing)
            
            SpotifyWebAPIController().spotifyWebAPIRequest(req: req, callback: { resp in
                if (resp.error) {
                    // handle error
                    print(resp.error, resp.errorData)
                }else{
                    guard let artists = resp.dataObject["artists"] as? [String: Any] else{
                        print("error - data object")
                        return
                    }
                    
                    guard let items = artists["items"] as? [Any] else{
                        print("error - items")
                        return
                    }
                    
                    self.parseItems(items: items)
                    
                }
                
            })
        //}
    }
    
    
    private func parseItems(items: [Any]){
        
        
        // parse the data
        for item in items {
            //itemDisp.enter()
            
            guard let json = item as? [String: Any] else{
                print("error - json")
                //itemDisp.leave()
                return
            }
            
            self.parseSingleItem(itemX: json)
        }
    }
    
    private func parseSingleItem(itemX: [String: Any]){
        self.artistData_DispatchQueue.async {
            // get id
            guard let id = itemX["id"] as? String else{
                print("error - id")
                return
            }
            
            // get name
            guard let name = itemX["name"] as? String else {
                print("error - name")
                return
            }
            
            // get image array
            guard let imgArray = itemX["images"] as? [Any] else {
                print("error - image 1")
                return
            }
            
            // get small img
            guard let smallImg = imgArray[0] as? [String: Any] else {
                print("error - image 2")
                return
            }
            
            // get small image object
            guard let imgURL = smallImg["url"] as? String else {
                print("error - image 3")
                return
            }
            
            let imgData = NSData(contentsOf: URL(string: imgURL)!)
            let uiImage = UIImage(data: imgData! as Data)
            
            let tempArtist = SpotifyArtistModel(
                                id: id,
                                image: uiImage!,
                                name: name
                            )
            
            DispatchQueue.main.async {
                self.artists.append(tempArtist)
            }
            
            
        }
    }
    

}

