//
//  ItemManagementSelected.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct ItemManagementSelected: View {
    
    @State private var isActive = false
    
    var body: some View {
        VStack {
            NavigationLink(isActive: $isActive) {
                ItemPhoto(isActive: $isActive)
            } label: {
                PlusCircle()
            }
        }
        .frame(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ItemManagementSelected_Previews: PreviewProvider {
    static var previews: some View {
        ItemManagementSelected()
    }
}
