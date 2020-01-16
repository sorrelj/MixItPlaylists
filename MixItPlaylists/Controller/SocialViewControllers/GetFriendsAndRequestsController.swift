//
//  GetFriendsAndRequestsController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 1/7/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import Foundation

struct AcceptDenyResponse {
    // error
    var error: Bool
    
    // message
    var message: String
    
    init(){
        self.error = false
        self.message = ""
    }
    
    init(error: Bool, message: String){
        self.error = error
        self.message = message
    }
}


final class GetFriendsAndRequestsController: ObservableObject {

    // friends list
    @Published var friendsList: [UserFriendsModel] = []
    // requests list
    @Published var requestsList: [SearchedUserModel] = []
    
    // show error alert
    @Published var showErrorAlert: Bool = false

    // parse users controller
    private var parseUsersController = ParseUsersController()
    
    /// MARK: Functions
    
    // get friends and requests
    func getFriendsAndRequests() {        
        // set the request
        let req = APIRequest(requestType: .GET, name: .getfriends, params: [:], withToken: true)
        
        // call request
        APINetworkController().apiNetworkRequest(req: req, callback: { resp in
            // check status code
            if resp.statusCode == 200 {
                
                // get friends array
                guard let friends = resp.body["friends"] as? [[String: String]] else{
                    print("ERROR getting friends array")
                    return
                }
                
                // get requests array
                guard let requests = resp.body["requests"] as? [[String: String]] else{
                    print("ERROR getting requests array")
                    return
                }
                
                // parse friends
                self.parseUsersController.parseAllUsers(users: friends, friends: true, callback: { friendsParsed in
                    // set friends list
                    self.friendsList = friendsParsed.friendUsers
                    
                    // get requests
                    self.parseUsersController.parseAllUsers(users: requests, friends: false, callback: { requestsParsed in
                        self.requestsList = requestsParsed.searchedUsers
                    })
                })
                
            }else{
                // show alert
                self.showErrorAlert = true
            }
        })
        
    }
    
    
    // accept friend request
    func acceptFriendRequest(username: String, callback: @escaping (AcceptDenyResponse)->()){
        // set request
        let req = APIRequest(requestType: .POST, name: .acceptfriendrequest, params: ["username": username], withToken: true)
        
        // send request
        APINetworkController().apiNetworkRequest(req: req, callback: { resp in
            // check status
            if resp.statusCode == 200 {
                // refresh friend list
                DispatchQueue.main.async {
                    self.getFriendsAndRequests()
                }
                
                return callback(AcceptDenyResponse())
            }else{
                // send error
                return callback(AcceptDenyResponse(error: true, message: resp.body["message"] as! String))
            }
        })
    }
    
    
}
