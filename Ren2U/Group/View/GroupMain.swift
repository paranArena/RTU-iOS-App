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
    
    @State private var groupSelection: GroupSelection = .group
    @State private var text = ""
    @State private var isFocused = false
    @EnvironmentObject var groupModel: GroupModel
    
    var body: some View {
        // horizontal padding 주지 말것! 즐겨찾기 이미지를 좌우 폭에 못 맞추게 된다.
        
        VStack(alignment: .center, spacing: 10) {
            
            SearchBar(text: $text, isFoucsed: $isFocused)
            
            if isFocused {
                Search()
            } else {
                GroupSelectionButton(selectionOption: $groupSelection)
                
                ZStack {
                    GroupSelected()
                        .offset(x: groupSelection == GroupSelection.group ? 0 : -SCREEN_WIDTH)
                        .overlay(CreateGroupButton())
                    NoticeSelected()
                        .offset(x: groupSelection == GroupSelection.notice ? 0 : SCREEN_WIDTH)
                }
            }
            
            Spacer()
        }
        .overlay(ShadowRectangle())
        .animation(.spring(), value: groupSelection)
    }
    
    @ViewBuilder
    func CreateGroupButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink {
                    CreateGroup()
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .foregroundColor(.Navy_1E2F97)
                        .background(Color.BackgroundColor)
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
