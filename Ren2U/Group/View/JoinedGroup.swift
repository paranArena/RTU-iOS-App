//
//  JoinedGroup.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct JoinedGroup: View {
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("가입된 그룹 목록")
                .foregroundColor(.LabelColor)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            VStack {
                ForEach(0..<10) { index in
                    NavigationLink {
                        GroupPage(groupInfo: GroupInfo.dummyGroups())
                    } label: {
                        JoinedGroupCell(info: GroupInfo.dummyGroups())
                    }
                }
            }
        }
        .frame(width: SCREEN_WIDTH)
    }
}

struct JoinedGroup_Previews: PreviewProvider {
    static var previews: some View {
        JoinedGroup()
    }
}
