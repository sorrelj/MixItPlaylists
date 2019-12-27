//
//  ProgressBar.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/20/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    
    /// MARK: Binding vars
    var progressPercent: CGFloat
    
    /// MARK: Input vars
    
    
    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray)
                    .opacity(0.3)
                Rectangle()
                    .foregroundColor(Color.pink)
                    .frame(width: g.size.width * self.progressPercent, height: 8.0)
            }
            .cornerRadius(5)
            .frame(width: g.size.width, height: 8.0)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    @State static var prog: CGFloat = 0.5
    @State static var songLength: String = "0:00"
    static var previews: some View {
        ProgressBar(progressPercent: prog)
    }
}
