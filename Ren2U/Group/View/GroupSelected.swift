//
//  GroupSelected.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct GroupSelected: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Section {
                    GroupFavorites()
                } header: {
                    Text("즐겨찾기")
                        .font(.system(size: 16, weight: .medium))
                }
                
                JoinedGroup()
            }
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}

struct GroupSelected_Previews: PreviewProvider {
    static var previews: some View {
        GroupSelected()
    }
}
