//
//  SignupView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 9/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    
    /// MARK: Variables
    
    // current tab from tab view
    @Binding var currentTab: Int
    
    
    // login username text
    @Binding var loginUsername: String
    // login password text
    @Binding var loginPassword: String
    
    // confirm account needed
    @Binding var confirmAccount: Bool
    
    // phone number
    @Binding var phoneNumber: String
    
    /// MARK: State vars
    
    // phone number text
    @State private var number: String = ""
    // username text
    @State private var registerUsername: String = ""
    // password text
    @State private var registerPassword: String = ""
    // confirm password text
    @State private var registerConfirmPassword: String = ""
    
    
    // sign up view controller
    @State private var signupManager = SignupViewController()
    
    
    // show alert
    @State private var showSignupAlert = false
    // alert object
    @State private var alertObj: AlertObject = AlertObject()

    // activity indicator
    @State private var showActivityIndicator: Bool = false
    
    
    // MARK: Functions
    
    // end keyboard editing
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    // create account button action
    private func createAccountButtonAction(){
        // make sure all required fields are filled
        if (self.number == "" || self.registerUsername == "" || self.registerPassword == "" || self.registerConfirmPassword == "") {
            
            // show alert error
            self.alertObj = AlertObject(title: "Alert", message: "Please Fill all Fields.", button: "OK")
            self.showSignupAlert = true
            
        }else if (self.registerPassword != self.registerConfirmPassword){
            
            // show error alert
            self.alertObj = AlertObject(title: "Alert", message: "Passwords must match", button: "OK")
            self.showSignupAlert = true
            
        }else{
            // add the activity indicator
            self.showActivityIndicator = true
            
            
            // sign up view controller sign up
            self.signupManager.signupUser(number: self.number, username: self.registerUsername, password: self.registerPassword, callback: { res in
                
                // remove activity indicator
                self.showActivityIndicator = false
                
                // check for error status
                if (!res.userCreated) {
                    
                    // error alert
                    self.alertObj = AlertObject(title: "Alert", message: res.message, button: "OK")
                    
                    self.showSignupAlert = true
                } else {
                    
                    //  user created
                                    
                    // set login username and password
                    self.loginUsername = self.registerUsername
                    //self.loginPassword = self.registerPassword
                    
                    // set phone number
                    self.phoneNumber = self.number
                    
                    // reset textfield text
                    self.number = ""
                    self.registerUsername = ""
                    self.registerPassword = ""
                    self.registerConfirmPassword = ""
                    
                    // go to confirm account
                    self.confirmAccount = true
                    
                }
                


            })
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: View
    
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
                        // Main Title
                        Text("Welcome")
                            .font(.custom("Helvetica-Bold", size: 40))
                            .foregroundColor(Color.white)
                            
                        // Sub title
                        Text("Create an Account Below to Start Listening")
                            .font(.custom("Helvetica", size: 18))
                            .foregroundColor(Color.white)
                    }
                    .frame(width: g.size.width, height: g.size.height/4)
                    .padding(.top, 20)
                    
                    /*
                    
                       2
                    
                    */
                    // text field vstack
                    VStack {
                        Spacer()
                                                
                        // phone number text field
                        
                        RoundedTextField(placeholder: "9991234567", stateBinding: self.$number, secureTextField: false)
                            .keyboardType(.numberPad)
                        
                        Spacer()
                        
                         // username text field
    
                        RoundedTextField(placeholder: "Username", stateBinding: self.$registerUsername, secureTextField: false)
                        
                        Spacer()
                        
                        // password text field
                        
                        RoundedTextField(placeholder: "Password", stateBinding: self.$registerPassword, secureTextField: true)
                        
                        Spacer()

                        // confirm password text field
                        
                        RoundedTextField(placeholder: "Confirm Password", stateBinding: self.$registerConfirmPassword, secureTextField: true)
                            
                        Spacer()

                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .frame(width: g.size.width, height: g.size.height/2)
                    
                        
                    /*
                    
                       3
                    
                    */
                    // temp button 3
                    VStack {
                        Button(action: self.createAccountButtonAction) {
                            Text("Create Account")
                                .font(.custom("Helvetica", size: 14))
                                .padding(.all, 12)
                                .frame(minWidth: 0, maxWidth: (g.size.width/3))
                                .background(Color.pink)
                                .foregroundColor(Color.white)
                        }
                        .cornerRadius(20)

                    }
                    .frame(width: g.size.width, height: g.size.height/4)
                    .padding(.bottom, 20)
                    .alert(isPresented: self.$showSignupAlert) {
                        Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), dismissButton: .cancel(Text(self.alertObj.button), action: {
                            
                        }))
                        
                    }
                        
                    
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

struct SignupView_Previews: PreviewProvider {
    @State static var currTab: Int = 2
    @State static var loginU: String = ""
    @State static var loginP: String = ""
    @State static var confirm: Bool = false
    @State static var phone: String = ""
    static var previews: some View {
        SignupView(currentTab: $currTab, loginUsername: $loginU, loginPassword: $loginP, confirmAccount: $confirm, phoneNumber: $phone)
    }
}
