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
        NavigationView {
            VStack {
                GroupSelectionButton(selectionOption: $groupSelection)
                
                TabView(selection: $groupSelection) {
                    GroupSelected()
                        .tag(GroupSelection.group)
                        .gesture(DragGesture()) // Swipe로 페이지 전환 막기
                    
                    NoticeSelected()
                        .tag(GroupSelection.notice)
                        .gesture(DragGesture())
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationBarHidden(true)
            .overlay { CreateGroupButton() }
            // horizontal padding 주지 말것! 즐겨찾기 이미지를 좌우 폭에 못 맞추게 된다.
        }
    }
    
    @ViewBuilder
    func CreateGroupButton() -> some View {
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

struct Group_Previews: PreviewProvider {
    static var previews: some View {
        GroupMain()
    }
}
