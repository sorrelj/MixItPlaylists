//
//  SelectUserImageScrollView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct SelectUserImageScrollView: View {
    // state variables
    
    // activity indicator
    @Binding var showActivityIndicator: Bool
    
        
    // binding
    @Binding var confirmAccount: Bool
    @Binding var phoneNumber: String
    @Binding var currentTab: Int
    
    @ObservedObject var getArtists: SelectUserImageViewController
    
    
    // init
    /*
    init(showActivityIndicator: Binding<Bool>, confirmAccount: Binding<Bool>, phoneNumber: Binding<String>, currentTab: Binding<Int>) {
        print("..INIT..")

        self._showActivityIndicator = showActivityIndicator
        self._confirmAccount = confirmAccount
        self._phoneNumber = phoneNumber
        self._currentTab = currentTab
                
        self.getArtists = SelectUserImageViewController()
    }
     */
    
    var body: some View {
        VStack {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack { //(alignment: .top, spacing: 0) {
                ForEach(self.getArtists.artists) { artist  in
                    NavigationLink(
                        destination: ConfirmUserImageView(artist: artist, confirmAccount: self.$confirmAccount, phoneNumber: self.$phoneNumber, currentTab: self.$currentTab)
                    ){
                        VStack {
                            // image
                            Image(uiImage: artist.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 10)
                                        
                            // name
                            Text(artist.name)
                                .font(.custom("Helvetica", size: 16))
                                .foregroundColor(Color.white)
                                            
                        }
                        .padding(.all, 25)
                        .onAppear(){
                            self.showActivityIndicator = false
                        }
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        }
    }
}


struct SelectUserImageScrollView_Previews: PreviewProvider {
    @State static var act: Bool = false
    @State static var con: Bool = true
    @State static var phone: String = ""
    @State static var curr: Int = 2
    @ObservedObject static var art = SelectUserImageViewController()
    static var previews: some View {
        SelectUserImageScrollView(showActivityIndicator: $act, confirmAccount: $con, phoneNumber: $phone, currentTab: $curr, getArtists: art)
    }
}

