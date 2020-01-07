//
//  SearchUserViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 1/4/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import Foundation

struct SocialRequestsResponse{
    // error
    var error: Bool
    
    // error message
    var message: String
    
    init(error: Bool, message: String){
        self.error = error
        self.message = message
    }
}

final class SearchUserViewController: ObservableObject {

    // searched list
    @Published var searchedUserList: [SearchedUserModel] = []

    // parse users controller
    private var parseUsersController = ParseUsersController()
    
    /// MARK: Functions
    func searchUser(username: String, callback: @escaping (SocialRequestsResponse)->()){
        // set request
        let req = APIRequest(requestType: .GET, name: .searchUsers, params: ["username": username], withToken: true)
        
        // perform request
        APINetworkController().apiNetworkRequest(req: req, callback: { resp in
            // if status code 200
            if resp.statusCode == 200 {
                guard let users = resp.body["users"] as? [[String: String]] else {
                    print("PARSE USERS ERROR")
                    return
                }
                
                // parse users
                self.parseUsersController.parseAllUsers(users: users, friends: false, callback: { resp in
                    // publish to view
                    self.searchedUserList = resp.searchedUsers
                    
                    // send callback
                    return callback(SocialRequestsResponse(error: false, message: ""))
                })
                
            }else{
                // send callback
                return callback(SocialRequestsResponse(error: true, message: resp.body["message"] as! String))
            }
        })
    }
    
    
    // send friend request to searched user
    func sendFriendRequest(username: String, callback: @escaping (SocialRequestsResponse)->()){
        
        // set request
        let req = APIRequest(requestType: .POST, name: .sendfriendrequest, params: ["username": username], withToken: true)
        
        // send the request
        APINetworkController().apiNetworkRequest(req: req, callback: { resp in
            // check for 200 status code
            if resp.statusCode == 200 {
                // send callback
                return callback(SocialRequestsResponse(error: false, message: ""))
            }else {
                // get error message
                
                // send callback
                return callback(SocialRequestsResponse(error: true, message: resp.body["message"] as! String))
            }
        })
    }
    
}
