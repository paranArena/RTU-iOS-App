//
//  GroupFavorites.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct GroupFavorites: View {
    
    @EnvironmentObject var groupModel: GroupModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(0..<5, id: \.self) { index in
                    VGroupFavoriteCell(info: GroupInfo.dummyGroup())
                }
            }
        }
    }
}

struct GroupFavorites_Previews: PreviewProvider {
    static var previews: some View {
        GroupFavorites()
    }
}
