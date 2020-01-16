//
//  FriendsRootView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 1/4/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import SwiftUI

struct FriendsRootView: View {
    
    /// MARK: State vars
    // selected user to accept/deny request
    @State private var selectedUser: SearchedUserModel = SearchedUserModel()
    
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    
    // show accept/deny alert
    @State private var showAcceptDenyAlert: Bool = false
    
    // show activity indicator
    @State private var showActivityIndicator: Bool = false
    
    /// MARK: Controllers
    @ObservedObject private var getFriendsViewController: GetFriendsAndRequestsController = GetFriendsAndRequestsController()
    
    /// MARK: Functions
    
    // user in request is tapped
    private func acceptDenyRequest(user: SearchedUserModel){
        if user.id.isEmpty {
            return
        }
        
        // set user
        self.selectedUser = user
        
        // set alert
        self.alertObj = AlertObject(title: "Info", message: "Friend request from "+user.id, button: "Accept")
        self.showAcceptDenyAlert = true
    }
    
    // accept request
    private func acceptFriendRequest() {
        if self.selectedUser.id.isEmpty {
            return
        }
        
        self.showActivityIndicator = true
        
        // send request to accept friend request
        self.getFriendsViewController.acceptFriendRequest(username: self.selectedUser.id, callback: { resp in
            // remove activity indicator
            self.showActivityIndicator = false
            
            // check for error
            if resp.error {
                // set alert
                print("ERROR")
            }
        })
    }
    
    // deny request
    
    var body: some View {
        ZStack{
            Color(UIColor(named: "background_main_dark")!)
                .edgesIgnoringSafeArea(.all)
                
            GeometryReader { g in
            VStack{
                
                VStack{
                    // Friends
                    HStack {
                        Text("Friends")
                            .font(.custom("Helvetica-Bold", size: 22))
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        if self.getFriendsViewController.friendsList.count > 50 {
                            Image(systemName: "50.circle.fill")
                                .font(.custom("Helvetica-Bold", size: 22))
                        }else{
                            Image(systemName: (self.getFriendsViewController.friendsList.count.description+".circle.fill"))
                                .font(.custom("Helvetica-Bold", size: 22))
                        }
                    }
                    .padding(.all, 25)
                    
                    // list of friends
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                        ForEach(self.getFriendsViewController.friendsList) { user in
                            VStack{
                                Image(uiImage: user.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:g.size.width/2, height:g.size.width/2)
                                    
                                Text(user.id)
                                    .font(.custom("Helvetica", size: 16))
                                    .padding(.top, 10)
                            }
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                        }
                        }
                        .padding(.leading,10)
                        .padding(.trailing, 10)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack{
                    // Requests
                    HStack {
                        Text("Friend Requests")
                            .font(.custom("Helvetica-Bold", size: 22))
                            .foregroundColor(Color.white)
                            
                        Spacer()
                        
                        if self.getFriendsViewController.requestsList.count > 50 {
                            Image(systemName: "50.circle.fill")
                                .font(.custom("Helvetica-Bold", size: 22))
                        }else{
                            Image(systemName: (self.getFriendsViewController.requestsList.count.description+".circle.fill"))
                                .font(.custom("Helvetica-Bold", size: 22))
                        }
    
                    }
                    .padding(.all, 25)
                    
                    // list of requests
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                        ForEach(self.getFriendsViewController.requestsList) { user in
                            VStack{
                                Image(uiImage: user.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:g.size.width/2, height:g.size.width/2)
                                    
                                Text(user.id)
                                    .font(.custom("Helvetica", size: 16))
                                    .padding(.top, 10)
                            }
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .onTapGesture {
                                self.acceptDenyRequest(user: user)
                            }
                        }
                        }
                        .padding(.leading,10)
                        .padding(.trailing, 10)
                    }
                    .alert(isPresented: self.$showAcceptDenyAlert) {
                        Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), primaryButton: .default(Text("Deny"), action: {
                            print("DENY")
                        }), secondaryButton: .default(Text(self.alertObj.button), action: {
                                self.acceptFriendRequest()
                        }))
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            }
            .onAppear() {
                self.getFriendsViewController.getFriendsAndRequests()
            }
            
            if self.showActivityIndicator {
                ActivityIndicator()
            }
            
        }
        
        .navigationBarTitle(Text("Friends"), displayMode: .inline)
                
                
        // Navigation button 1
        .navigationBarItems(trailing:
            NavigationLink(destination: SearchUsersView()){
                HStack{
                        
                    Image(systemName: "person.badge.plus.fill")
                        .foregroundColor(.white)
                        
                }
            }.font(.custom("Helvetica-Bold", size: 20))
        )
            
        .background(NavigationConfigurator { nc in
            nc.navigationBar.tintColor = .white
        })
        
    }
}

struct FriendsRootView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsRootView()
    }
}
