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
    private let selectionWidth = UIScreen.main.bounds.width / CGFloat(GroupSelection.allCases.count)
    
    var body: some View {
        // horizontal padding 주지 말것! 즐겨찾기 이미지를 좌우 폭에 못 맞추게 된다.
        
        VStack(alignment: .center, spacing: 10) {
            
            SearchBar(text: $text, isFoucsed: $isFocused)
                .padding(.horizontal, 20)
            
            if isFocused {
                Search()
                    .padding(.bottom, -10)
            } else {
                GroupSelectionButton()
                
                ZStack {
                    GroupSelected()
                        .offset(x: groupSelection == GroupSelection.group ? 0 : -SCREEN_WIDTH)
                        .overlay(CreateGroupButton())
                    NoticeSelected()
                        .offset(x: groupSelection == GroupSelection.notice ? 0 : SCREEN_WIDTH)
                }
                .padding(.bottom, -10)
            }
        }
        .overlay(ShadowRectangle())
        .animation(.spring(), value: groupSelection)
    }
    
    @ViewBuilder
    func GroupSelectionButton() -> some View {
        HStack {
            ForEach(GroupSelection.allCases, id: \.self) {  option in
                Button {
                    self.groupSelection  = option
                } label: {
                    Text(option.title)
                        .frame(width: selectionWidth)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 18))
                        .foregroundColor(self.groupSelection == option ? .Navy_1E2F97 : .Gray_ADB5BD)
                }

            }
        }
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
                        .padding(.horizontal, 10)
                        .padding(.vertical, 20)
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
