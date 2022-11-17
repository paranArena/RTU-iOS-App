//
//  ItemRegistration .swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct ProductCreateView_Photo: View {
    
    
    @StateObject var createProductVM: CreateProductViewModel
    @ObservedObject var managementVM: ManagementViewModel
    @EnvironmentObject var imagePickerVM: ImagePickerViewModel
    @Binding var isActive: Bool
    
    @State private var isPhotoNotSelected = true
    let photoLength = (SCREEN_WIDTH - 70) / 4
    
    
    var body: some View {
        VStack {

            Text("대여물품의 대표사진을 선택해주세요.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            
            ItemImages()
            
            Button {
                imagePickerVM.showDialog()
            } label: {
                Text("사진 등록하기")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    .foregroundColor(.navy_1E2F97)
            }
            .sheet(isPresented: $imagePickerVM.isShowingPicker) {
                ImagePickerView(sourceType: imagePickerVM.source == .library ? .photoLibrary : .camera, selectedImage: $createProductVM.image)
                    .ignoresSafeArea()
            }

            
            NavigationLink {
                ItemInformation(itemVM: createProductVM, managementVM: managementVM, isActive: $isActive)
            } label: {
                RightArrow(isDisabled: !createProductVM.isImageSelected)
            }
            .disabled(!createProductVM.isImageSelected)
            
        }
        .basicNavigationTitle(title: "물품 등록")
        .avoidSafeArea()
    }
    
    @ViewBuilder
    private func ItemImages() -> some View {
        ZoomableScrollView {
            if let image = createProductVM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .cornerRadius(20)
                    .clipped()
            }
        }
        .frame(maxWidth: 300, maxHeight: 300)
    }
}

//struct ItemRegistration_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemPhoto(itemVM: ItemViewModel(), isActive: .constant(true))
//    }
//}
