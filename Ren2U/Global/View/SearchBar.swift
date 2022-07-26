//
//  SearchBar.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/26.
//

import SwiftUI

struct SearchBar: View {
    
    @State private var searchText = ""
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.Gray_DEE2E6)
                TextField("I`ll Ren2U", text: $searchText)
            }
            .padding(5)
            .overlay {
                Capsule()
                    .stroke(Color.Gray_DEE2E6, lineWidth: 2)
            }
            
            Image(systemName: "bell")
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
