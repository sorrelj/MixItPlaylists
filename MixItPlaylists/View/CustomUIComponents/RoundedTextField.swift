//
//  RoundedTextField.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 9/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct RoundedTextField: View {
    
    // MARK: Variables
    
    //placeholder text
    let placeholder: String
    
    // binding var for text in textfield
    @Binding var stateBinding: String
    
    // bool to set as secure text field
    let secureTextField: Bool
    
    
    // MARK: VIEW
    
    var body: some View {
        VStack {
            if (secureTextField){
                SecureField(placeholder, text: $stateBinding)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .colorScheme(.light)
                    .cornerRadius(20)
            }else{
                TextField(placeholder, text: $stateBinding)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .colorScheme(.light)
                    .cornerRadius(20)

            }
        }
    }
}


struct RoundedTextField_Previews: PreviewProvider {
    @State static var stateBinding: String = ""
    static var previews: some View {
        RoundedTextField(placeholder: "Test", stateBinding: $stateBinding, secureTextField: false)
    }
}
