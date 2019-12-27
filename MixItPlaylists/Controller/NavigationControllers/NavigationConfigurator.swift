//
//  NavigationConfigurator.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 11/14/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import SwiftUI
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
