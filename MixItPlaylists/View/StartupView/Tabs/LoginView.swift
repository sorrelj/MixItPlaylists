//
//  LoginView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 9/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: Variables
    
    // setting root view 
    @Binding var rootViewType: RootViewTypes
    
    // username text
    @Binding var username: String
    //password text
    @Binding var password: String
    
    // confirm account
    @Binding var confirmAccount: Bool
    // fogot password window
    @Binding var forgotPassword: Bool
    
    // login view controller
    @State private var authManager = LoginViewController()
    
    // phone number
    @Binding var phoneNumber: String
    
    // activity indicator
    @State private var showActivityIndicator = false
    
    
    // show login alert
    @State private var showLoginAlert = false
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    // show confirm alert
    @State private var showConfirmAlert = false
    
    
    
    // MARK: Functions
    
    // end keyboard editing
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    // login button action
    private func loginButtonAction() {
        // check that username and password fields are not empty
        if (self.username == "" || self.password == "") {
            
            // show error alert
            self.alertObj = AlertObject(title: "Alert", message: "Please Fill all Fields.", button: "OK")
            self.showLoginAlert = true
            
        }else{
            
            // add activity indicator
            self.showActivityIndicator = true
            
            // login view controller login user
            self.authManager.loginUser(username: self.username, password: self.password, callback: { res in
                // remove activity indicator
                self.showActivityIndicator = false
                
                // check for error status
                if (res.status == .ERROR) {
                    // show error alert
                    self.alertObj = AlertObject(title: "Alert", message: res.message, button: "OK")
                    self.showLoginAlert = true
                    
                // check for unconfirmed
                }else if (res.status == .NOTCONFIRMED) {
                    // set phone number
                    self.phoneNumber = res.message
                    
                    self.alertObj = AlertObject(title: "Alert", message: "Please Confirm your Profile", button: "Continue")
                    
                    self.showLoginAlert = true
                    self.showConfirmAlert = true
                
                }else {
                    // user authorized
                    self.rootViewType = .HOME
                }
            })
        }
    }
    
    // Forgot password button
    private func forgotPasswordButtonAction() {
        self.forgotPassword = true
    }
    
    // Spotify info button
    private func spotifyInfoAction() {
        // open spotify.com
        let spotifyLink =  ExternalLinks().spotifyInfo
        
        if let url = URL(string: spotifyLink){
            if (UIApplication.shared.canOpenURL(url)){
                UIApplication.shared.open(url, options: [:])
            }else{
                // open in safari
            }
        }
    }
    

    // MARK: VIEW
    
    var body: some View {
        VStack (alignment: .center) {
            ZStack {
                Color(UIColor(named: "background_main_dark")!)
                    .edgesIgnoringSafeArea(.all)

                GeometryReader { g in
                    VStack{
                    /*
                     
                        1
                     
                     */
                    
                    // title vstack
                    VStack {
                        Spacer()
                        // Main Title
                        Text("Mix It Playlists")
                            .font(.custom("Helvetica-Bold", size: 40))
                            .foregroundColor(Color.white)
                            .padding(.bottom,10)
                        
                            
                        // Sub title
                        Text("Music Playlists Made Social")
                            .font(.custom("Helvetica", size: 20))
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .frame(width: g.size.width, height: g.size.height/4)
                    
                    /*
                    
                       2
                    
                    */
                    // text field vstack
                    VStack {
                        Spacer()
                        
                        // username text field
                        RoundedTextField(placeholder: "Username or Phone Number", stateBinding: self.$username, secureTextField: false)
                    
                        Spacer()
                        
                        // password text field
                        RoundedTextField(placeholder: "Password", stateBinding: self.$password, secureTextField: true)
                        
                        Spacer()
                            
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .frame(width: g.size.width, height: g.size.height/4)
                        
                    /*
                    
                       3
                    
                    */
                    // login button
                    VStack {
                        
                        HStack{
                            Spacer()
                            Button(action: self.forgotPasswordButtonAction){
                                Text("Forgot Password?")
                                    .font(.custom("Helvetica", size: 14))
                            }
                            .padding(.trailing, 30)
                        }
                        .padding(.bottom, 8)
                        
                        Button(action: self.loginButtonAction) {
                            Text("Login")
                                .font(.custom("Helvetica", size: 15))
                                .padding(.all, 8)
                                .frame(minWidth: 0, maxWidth: (g.size.width/4))
                                .background(Color.pink)
                                .foregroundColor(Color.white)
                        }
                        .cornerRadius(20)
                        
                        Spacer()

                    }
                    .frame(width: g.size.width, height: g.size.height/4)
                    //login button alert
                    .alert(isPresented: self.$showLoginAlert) {
                        Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), dismissButton: .default(Text(self.alertObj.button),
                            action: {
                                if (self.showConfirmAlert) {
                                    self.confirmAccount = true
                                }
                            })
                        )
    
                    }
                    
                    /*
                    
                       4
                    
                    */
                    // spotify info
                    VStack {
                        // powered by text
                        Text("Powered by")
                            .font(.custom("Helvetica", size: 16))
                            .foregroundColor(Color.white)
                        
                        // spotify button
                        Button(action: self.spotifyInfoAction) {
                            Image("Spotify_logo_white")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                .padding(.leading, 30)
                                .padding(.trailing, 30)
                                .frame(width: 2*g.size.width/5)
                                .foregroundColor(.white)
                                .background(Color(UIColor(named: "Spotify_color_green")!))
                        }
                        .cornerRadius(20)
                        .padding(.bottom, 10)
                        
                    }
                    .frame(width: g.size.width, height: g.size.height/4)

                    }
                }
                
                //loading view
                if self.showActivityIndicator {
                    ActivityIndicator()
                }
            }
        }
        .onTapGesture {
            self.endEditing()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var rootView: RootViewTypes = .AUTH
    @State static var uname: String = ""
    @State static var pword: String = ""
    @State static var forg: Bool = false
    @State static var confirm: Bool = false
    @State static var phone: String = ""
    static var previews: some View {
        LoginView(rootViewType: $rootView, username: $uname, password: $pword, confirmAccount: $confirm, forgotPassword: $forg, phoneNumber: $phone)
            .colorScheme(.dark)
    }
}
