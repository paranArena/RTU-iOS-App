//
//  Group.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

enum GroupSelection: Int, CaseIterable {
    case group
    case notice
    
    var title: String {
        switch self {
        case .group:
            return "그룹"
        case .notice:
            return "공지사항"
        }
    }
}

struct GroupMain: View {
    
    @State var groupSelection: GroupSelection = .group
    
    var body: some View {
        VStack {
            GroupSelectionButton(selectionOption: $groupSelection)
            
            if groupSelection == GroupSelection.group {
                GroupSelected()
            } else {
                NoticeSelected() 
            }
        }
        .overlay {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "plus.circle")
                        .resizable()
                        .foregroundColor(.Navy_1E2F97)
                        .frame(width: 60, height: 60)
                        .padding(10)
                }
            }
        }
    }
}

struct Group_Previews: PreviewProvider {
    static var previews: some View {
        GroupMain()
    }
}
