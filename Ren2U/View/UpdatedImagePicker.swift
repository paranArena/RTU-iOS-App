//
//  UpdatedImagePicker.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI
import UIKit
import Combine

struct UpdatedImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var imagePath: String
    @Environment(\.presentationMode) private var presentationMode
    var imageService = DeprecatedImageService.shared
    var cancellableSet: Set<AnyCancellable> = []
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<UpdatedImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<UpdatedImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: UpdatedImagePicker
        init(_ parent: UpdatedImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.imageService.post(image: image)
                    .sink { dataResponse in
                        print("비동기 테스트, sink")
                        if dataResponse.error != nil {
                            print(dataResponse.debugDescription)
                        } else {
                            self.parent.imagePath = dataResponse.value?.data ?? ""
                        }
                    }.store(in: &parent.cancellableSet)
                   
            }
            print("비동기 테스트, outer")
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

