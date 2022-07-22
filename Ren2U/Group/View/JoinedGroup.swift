//
//  JoinedGroup.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct JoinedGroup: View {
    
    var body: some View {
        
        VStack {
            Text("가입된 그룹 목록")
                .font(.system(size: 16, weight: .medium))
            ForEach(0..<10) { index in
                HGroupCell(info: GroupInfo.dummyGroup())
            }
        }
    }
}

//struct JoinedGroup_Previews: PreviewProvider {
//    static var previews: some View {
//        JoinedGroup()
//    }
//}
