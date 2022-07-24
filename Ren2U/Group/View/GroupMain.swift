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
    @EnvironmentObject var groupModel: GroupModel
    
    var body: some View {
        VStack {
            GroupSelectionButton(selectionOption: $groupSelection)
            
            ZStack {
                GroupSelected()
                    .offset(x: groupSelection == GroupSelection.group ? 0 : -SCREEN_WIDTH)
                NoticeSelected()
                    .offset(x: groupSelection == GroupSelection.notice ? 0 : SCREEN_WIDTH)
            }

            Spacer() // ZStack이 Tabbar 위에 올라가지 않도록 해줌)
        }
        .animation(.spring(), value: groupSelection)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarHidden(true)
        .navigationTitle(" ")
        .overlay(CreateGroupButton())
        // horizontal padding 주지 말것! 즐겨찾기 이미지를 좌우 폭에 못 맞추게 된다.
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
