//
//  SearchUsersView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 1/4/20.
//  Copyright © 2020 MixIt. All rights reserved.
//

import SwiftUI

struct SearchUsersView: View {
    
    /// MARK: State vars
    // search text
    @State private var searchText = ""
    
    // cancel button bool
    @State private var showCancelButton: Bool = false
    
    // show activity indicator
    @State private var showActivityIndicator: Bool = false
    
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    
    // show search alert
    @State private var showSearchAlert: Bool = false
    // show send request alert
    @State private var showSendRequestAlert: Bool = false
    // show confirm send
    @State private var showConfirmSendRequest: Bool = false
    
    // selected user
    @State private var selectedUser: SearchedUserModel = SearchedUserModel()
        
    // controller
    @ObservedObject private var searchUserController = SearchUserViewController()
    
    
    /// MARK: Private variables
    
    
    
    /// MARK: Functions

    // end keyboard editing
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    // search user
    private func searchUser() {
        guard !searchText.isEmpty else {
            // show alert
            return
        }
        
        // start search
        self.showActivityIndicator = true
        
        self.searchUserController.searchUser(username: self.searchText, callback: { resp in
            
            // remove activity indicator
            self.showActivityIndicator = false
            
            // if error show error
            if resp.error {
                self.alertObj = AlertObject(title: "Alert", message: resp.message, button: "OK")
                self.showSearchAlert = true
            }else{
                print(self.searchUserController.searchedUserList)
            }
        })
    }
    
    // add user (send friend request)
    private func addUserButtonAction(user: SearchedUserModel){
        // set user
        self.selectedUser = user
        
        // show confirm alert
        self.alertObj = AlertObject(title: "Info", message: ("Send friend request to " + user.id + "?"), button: "Send")
        self.showConfirmSendRequest = true
    }
    
    private func confirmSendFriendRequest() {
        if self.selectedUser.id.isEmpty {
            return
        }
        
        // add activity indicator
        self.showActivityIndicator = true
        
        // send request
        self.searchUserController.sendFriendRequest(username: self.selectedUser.id, callback: { resp in
            
            self.showActivityIndicator = false
            
            // check for error
            if resp.error {
                self.alertObj = AlertObject(title: "Alert", message: resp.message, button: "OK")
            }else{
                self.alertObj = AlertObject(title: "Info", message: "Friend request sent to "+self.selectedUser.id, button: "OK")
            }
            
            // delete from selected user
            self.selectedUser = SearchedUserModel()
            
            // show alert
            self.showSendRequestAlert = true
        })
    }
    
    
    // view
    var body: some View {
        ZStack{
            Color(UIColor(named: "background_main_dark")!)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { g in
            VStack {
                // Search view
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField("Username or Phone Number", text: self.$searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            self.searchUser()
                        })
                        .foregroundColor(.white)

                        Button(action: {
                            self.searchText = ""
                            self.searchUserController.searchedUserList = []
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(self.searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    if self.showCancelButton  {
                        Button("Cancel") {
                            self.endEditing()
                            self.searchText = ""
                            self.showCancelButton = false
                            self.searchUserController.searchedUserList = []
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .alert(isPresented: self.$showSearchAlert) {
                    Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), dismissButton: .default(Text(self.alertObj.button)))
                }
                
                // list of searched users
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(self.searchUserController.searchedUserList) { user in
                        VStack{
                            Image(uiImage: user.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:2*g.size.width/3, height:2*g.size.width/3)
                                
                            Text(user.id)
                                .font(.custom("Helvetica", size: 16))
                                .padding(.top, 10)
                        }
                        .frame(width: g.size.width)
                        .padding(.top, 25)
                        .onTapGesture {
                            self.addUserButtonAction(user: user)
                        }
                    }
                    .alert(isPresented: self.$showSendRequestAlert){
                        Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message),dismissButton: .default(Text(self.alertObj.button)))
                    }
                }
                .alert(isPresented: self.$showConfirmSendRequest) {
                    Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), primaryButton: .cancel(), secondaryButton: .default(Text(self.alertObj.button), action: {
                            self.confirmSendFriendRequest()
                    }))
                }
            }
            }
            
            if self.showActivityIndicator {
                ActivityIndicator()
            }
            
        }
        .navigationBarTitle(Text("Search Users"), displayMode: .large)
    }
}

struct SearchUsersView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUsersView()
    }
}
