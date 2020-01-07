//
//  ParseUsersController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 1/5/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import Foundation

// response
struct ParseUsersResponse {
    
    // friend data array
    
    // search data array
    var searchedUsers: [SearchedUserModel]
    
    // friend user data
    var friendUsers: [UserFriendsModel]
    
    init(){
        self.searchedUsers = []
        self.friendUsers = []
    }
    
    // search return
    init(searched: [SearchedUserModel]){
        self.searchedUsers = searched
        self.friendUsers = []
    }
    
    init(friends: [UserFriendsModel]){
        self.friendUsers = friends
        self.searchedUsers = []
    }
    
}


final class ParseUsersController {
    
    // get image controller
    var getImage: GetUserImage = GetUserImage()
    
    // parse users
    func parseAllUsers(users: [[String: String]], friends: Bool, callback: @escaping (ParseUsersResponse) -> ()){
        // dispatch group
        let disp = DispatchGroup()
        
        // set object array
        var userArray: [Any] = []
        
        // loop through all users
        for user in users {
            // get username
            let username = user["username"]!
            
            // disp enter
            disp.enter()
            
            // get image
            getImage.getUserImage(imageID: user["imageID"]!, callback: { image in
                
                // set user model
                var temp: Any
                
                // friends
                if friends {
                    temp = UserFriendsModel(username: username, image: image)
                // not friends
                }else{
                    temp = SearchedUserModel(username: username, image: image)
                }
                    
                
                // add to array
                userArray.append(temp)
                
                // leave disp
                disp.leave()
                
            })
            
        }
        
        disp.notify(queue: .main, execute: {
            if friends {
                callback(ParseUsersResponse(friends: userArray as! [UserFriendsModel]))
            }else{
                callback(ParseUsersResponse(searched: userArray as! [SearchedUserModel]))
            }
        })
        
    }
    
}
