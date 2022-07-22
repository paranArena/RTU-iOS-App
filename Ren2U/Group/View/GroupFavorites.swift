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
        VStack(alignment: .leading) {
            Text("즐겨찾기")
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<5, id: \.self) { index in
                        NavigationLink {
                            Text("Group!")
                        } label: {
                            VGroupFavoriteCell(info: GroupInfo.dummyGroup())
                        }
                    }
                }
                .padding(.leading, 20)
            }
        }
    }
}

struct GroupFavorites_Previews: PreviewProvider {
    static var previews: some View {
        GroupFavorites()
    }
}
