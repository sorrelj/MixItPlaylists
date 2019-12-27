//
//  ConfirmCreateAccountMainView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/14/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct ConfirmCreateAccountMainView: View {
    
    // State variables
    @State var selectUserImage: Bool = false
    
    // Binding variables

    // switch to confirm account
    @Binding var confirmAccount: Bool
    // stored phone number for api
    @Binding var phoneNumber: String
    // spotify authed bool
    @Binding var isSpotifyAuthed: Bool
    // change tab to login when going back
    @Binding var currentTab: Int
    
    
    var body: some View {
        VStack {
            if self.selectUserImage {
                if self.isSpotifyAuthed {
                    SelectUserImageView(confirmAccount: self.$confirmAccount, phoneNumber: self.$phoneNumber, currentTab: self.$currentTab)
                        
                } else {
                    SpotifyAuthView(isSpotifyAuthed: self.$isSpotifyAuthed)
                }
            }else{
                ConfirmAccountVeiw(showSelectUserImage: self.$selectUserImage, phoneNumber: self.$phoneNumber)
            }
        }
    }
}

struct ConfirmCreateAccountMainView_Previews: PreviewProvider {
    @State static var confirm: Bool = true
    @State static var phone: String = ""
    @State static var auth: Bool = false
    @State static var tab: Int = 2
    static var previews: some View {
        ConfirmCreateAccountMainView( confirmAccount: $confirm, phoneNumber: $phone, isSpotifyAuthed: $auth, currentTab: $tab)
    }
}
