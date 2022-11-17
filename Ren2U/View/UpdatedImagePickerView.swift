//
//  UpdatedImagePickerView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/11/17.
//


import UIKit
import SwiftUI

struct UpdatedImagePickerView: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage?
    @Binding var imagePath: String
    
    @EnvironmentObject var imagePickerVM: ImagePickerViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<UpdatedImagePickerView>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<UpdatedImagePickerView>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: UpdatedImagePickerView
        init(_ parent: UpdatedImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                Task {
                    parent.imagePath = await parent.imagePickerVM.upload(uiImage: image)
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


