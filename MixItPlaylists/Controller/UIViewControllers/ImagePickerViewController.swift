//
//  ImagePickerViewController.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 12/11/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePickerViewController: UIViewControllerRepresentable {
    @Binding var presentationMode: PresentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerViewController>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerViewController>) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePickerViewController
        
        init(_ parent: ImagePickerViewController) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imagePicked = info[.originalImage] as? UIImage {
                parent.image = imagePicked
            }
            parent.presentationMode.dismiss()
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.dismiss()
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

struct ImagePicker : View {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ImagePickerViewController(presentationMode: presentationMode, image: $image)
    }
}
