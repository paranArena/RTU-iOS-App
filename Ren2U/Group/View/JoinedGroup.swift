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
                .font(.system(size: 16, weight: .medium)) 
            VStack {
                ForEach(0..<10) { index in
                    NavigationLink {
                        Text("가입된 그룹 정보!")
                    } label: {
                        HGroupCell(info: GroupInfo.dummyGroup())
                    }
                }
            }
        }
    }
}

//struct JoinedGroup_Previews: PreviewProvider {
//    static var previews: some View {
//        JoinedGroup()
//    }
//}
