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
    let productData: ProductPreviewDto
    @Binding var selectedId: Int
    @Binding var callback: () -> ()
    @Binding var isShowingAlert: Bool
    
    @State private var buttonWidthSize: CGFloat = .zero
    @State private var isShowingRequestButton = false
    @State private var offset: CGFloat = .zero
    
    var body: some View {
        SwipeCell(cellId: productData.id, selectedCellId: $selectedId, buttonWidthSize: buttonWidthSize, isShowingRequestButton: $isShowingRequestButton, offset: $offset) {
            HStack(alignment: .center, spacing: 5) {
                if let thumbnailPath = productData.imagePath {
                    KFImage(URL(string: thumbnailPath))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(15)
                        .isHidden(hidden: thumbnailPath.isEmpty)

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
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.BackgroundColor)
        } button: {
            WidthSetterView(viewWidth: $buttonWidthSize) {
                HStack(alignment: .center, spacing: 0) {
                    Button {
                        withAnimation {
                            self.isShowingRequestButton = false
                            self.offset = .zero
                        }
                        isShowingAlert = true
                        callback = {
                            Task {
                                await manageVM.deleteProduct(productId: productData.id)
                                manageVM.searchClubProductsAll()
                            }
                        }
                    } label: {
                        Text("삭제")
                    }
                    .frame(width: 80, height: 80)
                    .background(Color.red_FF6155)
                    .foregroundColor(Color.white)
                }
            }
        }
    }
}

//struct ManageProductCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ManageProductCell()
//    }
//}
