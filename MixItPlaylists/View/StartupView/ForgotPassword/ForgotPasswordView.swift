//
//  ForgotPasswordView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/11/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    // forgot password view
    @Binding var forgotPassword: Bool
    
    // change between get code and change password
    @State private var changePassword: Bool = false
    
    var body: some View {
        VStack{
            if (self.changePassword) {
                ChangePasswordView(changePassword: self.$changePassword, forgotPassword: self.$forgotPassword)
            }else{
                GetForgotPasswordCodeView(forgotPassword: self.$forgotPassword, changePassword: self.$changePassword)
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    @State static var forg: Bool = true
    
    static var previews: some View {
        ForgotPasswordView(forgotPassword: $forg)
    }
}
