//
//  ChangePasswordView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/12/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct ChangePasswordView: View {
    // State vars
    @State private var username = ""
    @State private var resetCode = ""
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    
    // show forgot alert
    @State private var showChangeAlert = false
    @State private var showSuccessAlert = false
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    
    // forgot view controller
    @State private var authManager = ChangePasswordViewController()
    
    // Binding vars
    @Binding var changePassword: Bool
    @Binding var forgotPassword: Bool
    
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
        if (self.username == "" || self.resetCode == "" || self.newPassword == "" || self.confirmNewPassword == ""){
            // show error alert
            self.alertObj = AlertObject(title: "Alert", message: "Please Fill all Fields.", button: "OK")
            self.showChangeAlert = true
        }else if (self.newPassword != self.confirmNewPassword){
            // show error alert
            self.alertObj = AlertObject(title: "Alert", message: "Passwords must match!", button: "OK")
            self.showChangeAlert = true
        }else{
            
            // show activity indicator
            self.showActivityIndicator = true
            
            // do request
            self.authManager.changePassword(username: self.username, code: self.resetCode, password: self.newPassword , callback: { res in
                
                // remove activity indicator
                self.showActivityIndicator = false
                
                // check for error status
                if (!res.success) {
                    // show error alert
                    self.alertObj = AlertObject(title: "Alert", message: res.message, button: "OK")
                } else {
                    // Text send to phone number
                    self.alertObj = AlertObject(title: "Info", message: "Password changed successfully", button: "Login")
                    self.showSuccessAlert = true
                }
                
                self.showChangeAlert = true
            })
        }
    }
    
    // need reset code
    private func needResetCode() {
        self.changePassword = false
    }
    
    var body: some View {
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
                    Text("Change Password")
                        .font(.custom("Helvetica", size: 20))
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .frame(width: g.size.width, height: g.size.height/4)
            
                    
                VStack {
                    Spacer()
                    
                    HStack{
                        Text("Enter Password Reset Code")
                            .font(.custom("Helvetica", size: 16))
                            .foregroundColor(Color.white)
                    
                        Spacer()
                    }
                    .padding(.leading, 40)

                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        RoundedTextField(placeholder: "Reset Code", stateBinding: self.$resetCode, secureTextField: false)
                        
                        Spacer()
                        
                        RoundedTextField(placeholder: "Username or Phone Number", stateBinding: self.$username, secureTextField: false)
                        
                        Spacer()
                        
                        RoundedTextField(placeholder: "New Password", stateBinding: self.$newPassword, secureTextField: true)
                        
                        Spacer()
                        
                        RoundedTextField(placeholder: "Confirm New Password", stateBinding: self.$confirmNewPassword, secureTextField: true)
                        
                        Spacer()
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    
                    Spacer()
                    
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
                        .alert(isPresented: self.$showChangeAlert) {
                            Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), dismissButton: .default(Text(self.alertObj.button), action: {
                                    if (self.showSuccessAlert){
                                        self.forgotPassword = false
                                    }
                                }))
                        }
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .padding(.top, 20)
                }
                .frame(width: g.size.width, height: (g.size.height/2))
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: self.needResetCode){
                            Text("Need a Reset Code?")
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

struct ChangePasswordView_Previews: PreviewProvider {
    @State static var change: Bool = true
    @State static var forg: Bool = true
    static var previews: some View {
        ChangePasswordView(changePassword: $change, forgotPassword: $forg)
    }
}
