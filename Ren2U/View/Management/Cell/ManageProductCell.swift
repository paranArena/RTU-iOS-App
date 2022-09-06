//
//  ManageProductCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/06.
//

import SwiftUI
import Kingfisher

struct ManageProductCell: View {
    
    @ObservedObject var manageVM: ManagementViewModel
    let productData: ProductResponseData
    @Binding var selectedId: Int
    
    var body: some View {
        CellWithTwoSlideButton(okMessage: "수정", cancelMessage: "삭제", cellID: productData.id, selectedID: $selectedId) {
            HStack(alignment: .center, spacing: 5) {
                if let thumbnailPath = productData.imagePath {
                    KFImage(URL(string: thumbnailPath))
                        .onFailure { err in
                            print(err.errorDescription ?? "KFImage Optional err")
                        }
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(20)
                    
                }
               
                VStack(alignment: .leading) {
                    Text(productData.name)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    
                    Text("\(productData.clubName)")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.gray_ADB5BD)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 5) {
                    Text(productData.left.productStatus())
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    Text("\(productData.left)/\(productData.max)")
                        .font(.custom(CustomFont.RobotoMedium.rawValue, size: 16))
                }
                .foregroundColor(productData.left.productColor())
            }
            .frame(maxWidth: .infinity)
            .background(Color.BackgroundColor)
        } okCallback: {
            print("ManageProductCell okCallBack")
        } cancelCallback: {
            Task {
                await manageVM.deleteProduct(productId: productData.id)
            }
        }

    }
}

//struct ManageProductCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ManageProductCell()
//    }
//}
