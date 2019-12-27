//
//  HomeInfoView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct HomeInfoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // root view
    @Binding var rootView: RootViewTypes
    
    // logout controller
    @State private var logoutController = LogoutViewController()
    
    // show confirm logout
    @State private var showConfirmLogout: Bool = false
    
    // alert object
    @State private var alertObj: AlertObject = AlertObject()
    
    /// MARK: Functions
    
    // logout button action
    private func logoutButtonAction() {
        self.alertObj = AlertObject(title: "Alert", message: "Are you sure you want to logout?", button: "Logout")
        self.showConfirmLogout = true
        
    }
    
    private func backButtonAction(){
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func logout() {
        logoutController.logout(callback: { stat in
            if (stat){
                self.rootView = .AUTH
            }else{
                print("LOGOUT ERROR")
            }
        })
    }
    
    var body: some View {
        VStack (alignment: .center) {
            ZStack {
                Color(UIColor(named: "background_main_dark")!)
                    .edgesIgnoringSafeArea(.all)
                
        
                GeometryReader { g in
                VStack{
               
                    VStack{
                        // Main Title
                        Text("Mix It Playlists")
                            .font(.custom("Helvetica-Bold", size: 40))
                            .foregroundColor(Color.white)
                            .padding(.top, 35)
                    }

                    Spacer()
                    
                    VStack {
                        Text("Mix It Playlists generates live collaborative playlists for everyday music enthusiasts in any environment. Using the Spotify platform, this application allows you to create custom playlists and invite others to request songs straight to your device in real time! This enables DJs to play music their listeners want to hear and allows personal users to discover new songs through the help of their friends. Mix It Playlists turns music social, as it should be progressing through the twenty-first century.")
                            .font(.custom("Helvetica", size: 18))
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                            .padding(.leading, 25)
                            .padding(.trailing, 25)
                    }.frame(minWidth: g.size.width, minHeight: g.size.height/3)
                    
                    Spacer()
                    
                    VStack {
                        
                        Button(action: self.logoutButtonAction){
                            Text("Logout")
                                .font(.custom("Helvetica", size: 16))
                                .padding(.top, 8)
                                .padding(.bottom, 8)
                                .padding(.leading, 30)
                                .padding(.trailing, 30)
                                .foregroundColor(.white)
                                .background(Color.pink)
                        }
                        .cornerRadius(20)
                        .padding(.bottom, 20)
                        .alert(isPresented: self.$showConfirmLogout) {
                            Alert(title: Text(self.alertObj.title), message: Text(self.alertObj.message), primaryButton: .cancel(), secondaryButton: .default(Text(self.alertObj.button), action: {
                                    self.logout()
                                })
                            )
                        }
                              
                    }
                }}
            }
        }
        .navigationBarItems(leading:
            Button(action: self.backButtonAction){
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

struct HomeInfoView_Previews: PreviewProvider {
    @State static var root: RootViewTypes = .HOME
    static var previews: some View {
        HomeInfoView(rootView: $root).colorScheme(.dark)
    }
}
