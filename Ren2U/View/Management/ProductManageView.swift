//
//  ItemManagementSelected.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct ProductManageView: View {
    
    @State private var isActive = false
    @State private var selectedCellId = -1
    @ObservedObject var managementVM: ManagementViewModel
    
    @State private var callback: () -> () = { print("callback")}
    @State private var isShowingAlert = false
    
    var body: some View {
        ScrollView {
            Group {
                SwipeResettableView(selectedCellId: $selectedCellId) {
                    ForEach(managementVM.products.indices, id: \.self) { i in
                        ManageProductCell(manageVM: managementVM, productData: managementVM.products[i], selectedId: $selectedCellId, callback: $callback, isShowingAlert: $isShowingAlert)
                    }
                }
                .isHidden(hidden: managementVM.products.isEmpty)
                
                Text("관리 중인 물품이 없습니다.")
                    .font(.custom(CustomFont.NSKRBold.rawValue, size: 20))
                    .foregroundColor(.gray_DEE2E6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .isHidden(hidden: !managementVM.products.isEmpty)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottomTrailing) {
            NavigationLink(isActive: $isActive) {
                ProductCreateView_Photo(createProductVM: CreateProductViewModel(clubId: managementVM.clubData.id, clubName: managementVM.clubData.name), managementVM: managementVM, isActive: $isActive)
            } label: {
                PlusCircleImage()
            }
        }
        .alert("물품을 삭제하시겠습니까?", isPresented: $isShowingAlert, actions: {
            Button("취소", role: .cancel) {}
            Button("예") {
                callback()
            }
        })
        .avoidSafeArea()
    }
}

//struct ItemManagementSelected_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemManagementSelected()
//    }
//}
