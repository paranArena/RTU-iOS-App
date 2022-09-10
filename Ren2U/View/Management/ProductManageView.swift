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
            SwipeResettableView(selectedCellId: $selectedCellId) {
                ForEach(managementVM.products.indices, id: \.self) { i in
                    ManageProductCell(manageVM: managementVM, productData: managementVM.products[i], selectedId: $selectedCellId, callback: $callback, isShowingAlert: $isShowingAlert)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottomTrailing) {
            NavigationLink(isActive: $isActive) {
                ItemPhoto(itemVM: ItemViewModel(clubId: managementVM.clubData.id), managementVM: managementVM, isActive: $isActive)
            } label: {
                PlusCircle()
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
