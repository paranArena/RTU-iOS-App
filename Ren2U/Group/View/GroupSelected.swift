//
//  GroupSelected.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct GroupSelected: View {
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                GroupFavorites()
                JoinedGroup()
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
            }
        }
    }
}

struct GroupSelected_Previews: PreviewProvider {
    static var previews: some View {
        GroupSelected()
    }
}
