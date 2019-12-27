//
//  GetForgotPasswordCodeView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/12/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct GetForgotPasswordCodeView: View {
    // state vars
    @State private var phoneNumber: String = ""
    
    // show forgot alert
    @State private var showForgotAlert = false
    @State private var showSuccessAlert = false
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    
    // forgot view controller
    @State private var forgotManager = ForgotPasswordViewController()
    
    // binding vars
    @Binding var forgotPassword: Bool
    @Binding var changePassword: Bool
    
    // activity indicator
    @State private var showActivityIndicator: Bool = false
    
    // MARK: Functions
    
    // end keyboard editing
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    // go back button
    private func cancelButtonAction() {
        self.forgotPassword = false
    }
    
    // submit http request
    private func submitButtonAction() {
        if (self.phoneNumber == ""){
            // show error alert
            self.alertObj = AlertObject(title: "Alert", message: "Please Enter Phone Number.", button: "OK")
            self.showForgotAlert = true
        }else{
            // add activity indicator
            self.showActivityIndicator = true
            
            // do request
            self.forgotManager.forgotPassword(number: self.phoneNumber, callback: { res in
                
                // remove activity indicator
                self.showActivityIndicator = false
                
                // check for error status
                if (!res.codeSent) {
                    // show error alert
                    self.alertObj = AlertObject(title: "Alert", message: res.message, button: "OK")
                } else {
                    // Text send to phone number
                    self.alertObj = AlertObject(title: "Info", message: "Password reset code sent to "+self.phoneNumber, button: "Continue")
                    self.showSuccessAlert = true
                }
                
                self.showForgotAlert = true
            })
        }
    }
    
    // go straight to change password
    private func alreadyHaveCode() {
        self.changePassword = true
    }
    
    var body: some View {
        ZStack {
        Color(UIColor(named: "background_main_dark")!)
            .edgesIgnoringSafeArea(.all)
            
            GeometryReader { g in
                VStack{
                
                // title vstack
                VStack {
                    Spacer()
                    // Main Title
                    Text("Mix It Playlists")
                        .font(.custom("Helvetica-Bold", size: 40))
                        .foregroundColor(Color.white)
                        .padding(.bottom,10)
                    
                        
                    // Sub title
                    Text("Forgot Password")
                        .font(.custom("Helvetica", size: 20))
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .frame(width: g.size.width, height: g.size.height/4)
            
                // enter information
                VStack {
                    HStack{
                        Text("Enter Phone Number")
                            .font(.custom("Helvetica", size: 16))
                            .foregroundColor(Color.white)
                    
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .padding(.bottom, 15)
                    
                    
                    RoundedTextField(placeholder: "Phone number", stateBinding: self.$phoneNumber, secureTextField: false)
                        .keyboardType(.numberPad)
                    
                    HStack {
                        Button(action: self.cancelButtonAction) {
                            Text("Cancel")
                                .font(.custom("Helvetica", size: 15))
                                .padding(.all, 8)
                                .frame(minWidth: 0, maxWidth: (g.size.width/4))
                                .background(Color.pink)
                                .foregroundColor(Color.white)
                        }
                        .cornerRadius(20)
                        
                        Spacer()
                        
                        Button(action: self.submitButtonAction) {
                            Text("Submit")
                                .font(.custom("Helvetica", size: 15))
                                .padding(.all, 8)
                                .frame(minWidth: 0, maxWidth: (g.size.width/4))
                                .background(Color.pink)
                                .foregroundColor(Color.white)
                        }
                        .cornerRadius(20)
                        .alert(isPresented: self.$showForgotAlert) {
                            Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), dismissButton: .default(Text(self.alertObj.button), action: {
                                    if (self.showSuccessAlert){
                                        self.changePassword = true
                                    }
                                }))
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
                .frame(width: g.size.width, height: g.size.height/2)
                
                    
                // already have code button
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: self.alreadyHaveCode){
                            Text("Already have Reset Code?")
                                .font(.custom("Helvetica", size: 14))
                        }
                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
                .frame(width: g.size.width, height: (g.size.height/4))
                
                }
            }
            
            if self.showActivityIndicator {
                ActivityIndicator()
            }
            
        }
        .onTapGesture {
            self.endEditing()
        }
    }
}

struct GetForgotPasswordCodeView_Previews: PreviewProvider {
    @State static var forg: Bool = true
    @State static var change: Bool = false
    static var previews: some View {
        GetForgotPasswordCodeView(forgotPassword: $forg, changePassword: $change)
            .colorScheme(.dark)
    }
}

