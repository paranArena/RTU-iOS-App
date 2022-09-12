//
//  ItemRegistration .swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct ItemPhoto: View {
    
    
    @StateObject var itemVM: ItemViewModel
    @ObservedObject var managementVM: ManagementViewModel
    @Binding var isActive: Bool
    
    @State private var isPhotoNotSelected = true
    let photoLength = (SCREEN_WIDTH - 70) / 4
    
    
    var body: some View {
        VStack {
            Text("대여물품의 대표사진을 선택해주세요.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            
            ItemImages()
            
            Button {
                itemVM.showImagePicker()
            } label: {
                Text("사진 등록하기")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    .foregroundColor(.navy_1E2F97)
            }
            
            NavigationLink {
                ItemInformation(itemVM: itemVM, managementVM: managementVM, isActive: $isActive)
            } label: {
                RightArrow(isDisabled: !itemVM.isImageSelected)
            }
            .disabled(!itemVM.isImageSelected)
            
        }
        .basicNavigationTitle(title: "물품 등록")
        
        .sheet(isPresented: $itemVM.showPicker, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $itemVM.image)
        })
        .avoidSafeArea()
    }
    
    @ViewBuilder
    private func ItemImages() -> some View {
        ZoomableScrollView {
            if let image = itemVM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .cornerRadius(20)
                    .clipped()
            }
        }
        .frame(maxWidth: 300, maxHeight: 300)
        //  이미지 여러장 등록할 때 이용
        //        let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)
//        LazyVGrid(columns: columns, spacing: 10) {
//            ForEach(itemVM.image.indices, id: \.self) { i in
//                Image(uiImage: itemVM.image[i])
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: photoLength, height: photoLength)
//                    .cornerRadius(15)
//            }
//        }
    }
}

//struct ItemRegistration_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemPhoto(itemVM: ItemViewModel(), isActive: .constant(true))
//    }
//}
