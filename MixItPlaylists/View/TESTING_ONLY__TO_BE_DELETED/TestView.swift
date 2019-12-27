//
//  TestView.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/18/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct TestView: View {
    
    @Binding var notificationNumberIcon: String
    
    var body: some View {
        VStack{
            Button(action: {self.notificationNumberIcon = "1.circle.fill"}){
                Text("PRESS ME")
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    @State static var test: String = ""
    static var previews: some View {
        TestView(notificationNumberIcon: $test)
    }
}
