//
//  ItemCategory.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct ItemCategory: View {
    
    @Binding var category: Category?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                Button {
                    self.category = category
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(category.rawValue)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                        .padding(.leading, 10)
                        .foregroundColor(.primary)
                }
                Divider()
            }
        }
        .basicNavigationTitle(title: "카테고리")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ItemCategory_Previews: PreviewProvider {
    static var previews: some View {
        ItemCategory(category: .constant(.book))
    }
}
