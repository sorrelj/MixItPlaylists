//
//  SelectUserImageView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/17/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct SelectUserImageView: View {
    
    // State
    @State private var showActivityIndicator: Bool = true
    
    @Binding var confirmAccount: Bool
    @Binding var phoneNumber: String
    @Binding var currentTab: Int
    
    // get artists
    @ObservedObject var getArtists = SelectUserImageViewController()
    
//    init(confirmAccount: Binding<Bool>, phoneNumber: Binding<String>, currentTab: Binding<Int>){
//        print("INIT")
//
//        self._confirmAccount = confirmAccount
//        self._phoneNumber = phoneNumber
//        self._currentTab = currentTab
//    }
    
    var body: some View {
        NavigationView{
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
                        
                            
                        // Sub title
                        Text("Select Favorite Artist")
                            .font(.custom("Helvetica", size: 20))
                            .foregroundColor(Color.white)
                        Spacer()
                    }.frame(width: g.size.width, height: g.size.height/4)
                
                    // List
                    VStack {
                        SelectUserImageScrollView(showActivityIndicator: self.$showActivityIndicator, confirmAccount: self.$confirmAccount, phoneNumber: self.$phoneNumber, currentTab: self.$currentTab, getArtists: self.getArtists)
                    }
                    .frame(width: g.size.width, height: 5*(g.size.height/8))
                    
                    VStack {
                        Spacer()
                        HStack{
                            Spacer()
                            Button(action: {print("test")}){
                                Text("Search More Artists")
                                    .font(.custom("Helvetica", size: 14))
                            }
                            Spacer()
                        }
                        .padding(.bottom, 20)
                    }.frame(width: g.size.width, height: g.size.height/8)
                    
                }}
                
                if self.showActivityIndicator {
                    ActivityIndicator()
                }
                
            }
            .navigationBarTitle("")
            .background(NavigationConfigurator { nc in
                nc.navigationBar.setBackgroundImage(UIImage(),for: .default)
                nc.navigationBar.shadowImage = UIImage()
                nc.navigationBar.tintColor = .white
            })
            .navigationBarHidden(true)
        }
    }
}

struct SelectUserImageView_Previews: PreviewProvider {
    @State static var confirm: Bool = true
    @State static var phone: String = ""
    @State static var curr: Int = 2
    static var previews: some View {
        SelectUserImageView(confirmAccount: $confirm, phoneNumber:  $phone, currentTab: $curr)
    }
}
