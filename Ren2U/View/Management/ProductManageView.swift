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
    
    var body: some View {
        SlideResettableScrollView(selectedCellId: $selectedCellId) {
            ForEach(managementVM.products.indices, id: \.self) { i in
                ManageProductCell(manageVM: managementVM, productData: managementVM.products[i], selectedId: $selectedCellId)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottomTrailing) {
            NavigationLink(isActive: $isActive) {
                ItemPhoto(itemVM: ItemViewModel(clubId: managementVM.clubData.id), isActive: $isActive)
            } label: {
                PlusCircle()
            }
        }
        .avoidSafeArea()
    }
}

//struct ItemManagementSelected_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemManagementSelected()
//    }
//}
