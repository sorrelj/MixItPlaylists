//
//  ConfirmAccountVeiw.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/17/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct ConfirmAccountVeiw: View {
    
    // MARK: state variables
    
    @State var confirmCode: String = ""
    @State private var showConfirmAlert: Bool = false
    @State var showSuccessAlert: Bool = false
    
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    
    // confirm view controller
    @State private var confirmManager = ConfirmUserViewController()
    
    // resend view controller
    @State private var resendManager = ResendConfirmationCodeViewController()
    
    // activity indicator
    @State private var showActivityIndicator: Bool = false
    
    /// MARK:  binding variables
    
    @Binding var showSelectUserImage: Bool
    @Binding var phoneNumber: String
    
    
    
    // MARK: Functions
    
    // end keyboard editing
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    // submit code
    private func submitConfirmCode() {
        if (self.confirmCode == ""){
            // show error alert
            self.alertObj = AlertObject(title: "Alert", message: "Please enter Confirmation Code sent to your phone number.", button: "OK")
            self.showConfirmAlert = true
        }else{
            // show activity indicator
            self.showActivityIndicator = true
            
            // do request
            self.confirmManager.confirmUser(number: self.phoneNumber, code: self.confirmCode, callback: { res in
                
                // remove activity indicator
                self.showActivityIndicator = false
                
                // check for error status
                if (!res.success) {
                    // show error alert
                    self.alertObj = AlertObject(title: "Alert", message: res.message, button: "OK")
                } else {
                    // Text send to phone number
                    self.alertObj = AlertObject(title: "Info", message: "Phone Number has been Confirmed.", button: "Continue")
                    self.showSuccessAlert = true
                }
                
                self.showConfirmAlert = true
            })
        }
    }
    
    // resend code
    private func resendConfirmCode() {
        if (self.phoneNumber != ""){
            // show activity indicator
            self.showActivityIndicator = true
            
            self.resendManager.resendCode(number: self.phoneNumber, callback: { res in
                // remove activity indicator
                self.showActivityIndicator = false
                
                // check success
                if (!res.success){
                    self.alertObj = AlertObject(title: "Alert", message: res.message, button: "OK")
                }else{
                    // show resent success
                    self.alertObj = AlertObject(title: "Info", message: "A new Confirmation Code has been sent to your Phone Number.", button: "OK")
                }
                self.showConfirmAlert = true
            })
        }
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
                    Text("Confirm Phone Number")
                        .font(.custom("Helvetica", size: 20))
                        .foregroundColor(Color.white)
                    Spacer()
                }.frame(width: g.size.width, height: g.size.height/4)
                
                // enter code vstack
                VStack {
                    HStack{
                        Text("Enter Confirmation Code")
                            .font(.custom("Helvetica", size: 16))
                            .foregroundColor(Color.white)
                    
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .padding(.bottom, 15)
                    
                    
                    RoundedTextField(placeholder: "Confirmation Code", stateBinding: self.$confirmCode, secureTextField: false)
                        .keyboardType(.numberPad)
                    
                    HStack {
                        Button(action: self.submitConfirmCode) {
                            Text("Submit")
                                .font(.custom("Helvetica", size: 15))
                                .padding(.all, 8)
                                .frame(minWidth: 0, maxWidth: (g.size.width/4))
                                .background(Color.pink)
                                .foregroundColor(Color.white)
                        }
                        .cornerRadius(20)
                        .alert(isPresented: self.$showConfirmAlert) {
                            Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), dismissButton: .default(Text(self.alertObj.button), action: {
                                    if (self.showSuccessAlert){
                                        self.showSelectUserImage = true
                                    }
                                }))
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
                .frame(width: g.size.width, height: g.size.height/2)
                
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: self.resendConfirmCode){
                            Text("Resend Confirmation Code")
                                .font(.custom("Helvetica", size: 14))
                        }
                        Spacer()
                    }
                    .padding(.bottom, 20)
                }.frame(width: g.size.width, height: g.size.height/4)
                
            }}
            
            if self.showActivityIndicator {
                ActivityIndicator()
            }
            
        }
        .onTapGesture {
            self.endEditing()
        }
    }
}

struct ConfirmAccountVeiw_Previews: PreviewProvider {
    @State static var showImg: Bool = false
    @State static var phone: String = ""
    static var previews: some View {
        ConfirmAccountVeiw(showSelectUserImage: $showImg, phoneNumber: $phone).colorScheme(.dark)
    }
}
