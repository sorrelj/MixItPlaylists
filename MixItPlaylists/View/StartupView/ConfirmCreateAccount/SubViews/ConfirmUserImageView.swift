//
//  ConfirmUserImageView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/19/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct ConfirmUserImageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // state
    @State var showConfirmAlert: Bool = false
    @State private var confirmManager = ConfirmUserImageViewController()
    @State var showSuccessAlert: Bool = false
    
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    
    // activity indicator
    @State private var showActivityIndicator: Bool = false
    
    // vars
    var artist: SpotifyArtistModel
   
    
    // binding
    @Binding var confirmAccount: Bool
    @Binding var phoneNumber: String
    @Binding var currentTab: Int
    
    /// MARK: Functions
//    init(artist: SpotifyArtistModel, confirmAccount: Binding<Bool>, phoneNumber: Binding<String>, currentTab: Binding<Int>) {
//
//        self.artist = artist
//        self._confirmAccount = confirmAccount
//        self._phoneNumber = phoneNumber
//        self._currentTab = currentTab
//    }
    
    
    // go back action
    func goBackButtonAction() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func confirmButtonAction() {
        // activity indicator
        self.showActivityIndicator = true
        
        self.confirmManager.confirmImage(number: self.phoneNumber, id: self.artist.id, callback: { res in
            
            // remove activity indicator
            self.showActivityIndicator = false
            
            // check success
            if (!res.success){
                self.alertObj = AlertObject(title: "Alert", message: res.message, button: "OK")
            }else{
                // show resent success
                self.alertObj = AlertObject(title: "Info", message: "Your Profile has been Created.", button: "Login")
                self.currentTab = 2
                self.showSuccessAlert = true
            }
            self.showConfirmAlert = true
        })
        
        
        
    }
    
    var body: some View {
        ZStack {
        Color(UIColor(named: "background_main_dark")!)
            .edgesIgnoringSafeArea(.all)
            
            GeometryReader { g in
            VStack {
                
                // title vstack
                VStack {
                    Spacer()
                    // Main Title
                    Text("Mix It Playlists")
                        .font(.custom("Helvetica-Bold", size: 40))
                        .foregroundColor(Color.white)
                        .padding(.bottom,10)
                        .padding(.top,10)
                    
                        
                    // Sub title
                    Text("Confirm Profile Image")
                        .font(.custom("Helvetica", size: 20))
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .frame(maxWidth: g.size.width, maxHeight: g.size.height/4)
            
        
                
                // image and username
                VStack {

                    Image(uiImage: self.artist.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: g.size.width/2, height: g.size.width/2)

                }
                .frame(minWidth: g.size.width, minHeight: g.size.height/2)

                
                VStack {
                    HStack {
                        Spacer()
                        
//                        Button(action: self.goBackButtonAction){
//                            Text("Go Back")
//                                .font(.custom("Helvetica", size: 15))
//                                .padding(.all, 8)
//                                .frame(minWidth: 0, maxWidth: (g.size.width/4))
//                                .background(Color.pink)
//                                .foregroundColor(Color.white)
//                        }
//                        .cornerRadius(20)
//
//                        Spacer()
//
//                        Spacer()
                        
                        Button(action: self.confirmButtonAction){
                            Text("Confirm")
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
                                        self.confirmAccount = false
                                    }
                                }))
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 25)
                }
                .frame(maxWidth: g.size.width, maxHeight: g.size.height/4)
                
                
            }
            }
            
            if self.showActivityIndicator {
                ActivityIndicator()
            }
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarItems(leading:
            Button(action: self.goBackButtonAction){
                HStack{
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                    Text("Back")
                        .foregroundColor(.white)
                }
            }.font(.custom("Helvetica", size: 20))
        )
    }
}

struct ConfirmUserImageView_Previews: PreviewProvider {
    static var artist = SpotifyArtistModel(id: "", image: UIImage(), name: "Test")
    @State static var phone: String = ""
    @State static var confirmAccount: Bool = true
    @State static var current: Int = 2
    static var previews: some View {
        ConfirmUserImageView(artist: artist, confirmAccount: $confirmAccount, phoneNumber: $phone, currentTab: $current)
    }
}
