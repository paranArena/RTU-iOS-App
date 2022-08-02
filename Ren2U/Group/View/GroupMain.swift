//
//  Group.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct GroupMain: View {
    
    @State private var groupSelection: GroupSelection = .group
    @State private var text = ""
    @State private var isSearchBarFocused = false
    @EnvironmentObject var groupModel: GroupModel
    private let selectionWidth = UIScreen.main.bounds.width / CGFloat(GroupSelection.allCases.count)
    
    var body: some View {
        // horizontal padding 주지 말것! 즐겨찾기 이미지를 좌우 폭에 못 맞추게 된다.
        
        VStack(alignment: .center, spacing: 10) {
            NavigationView {
                VStack(alignment: .center, spacing: 10) {
                    SearchBar(text: $text, isFoucsed: $isSearchBarFocused)
                        .padding(.horizontal, 20)
                    
                    Search()
                        .padding(.bottom, -10)
                        .isHidden(hidden: !isSearchBarFocused)
                    
                    Group {
                        GroupSelectionButton()
                        ZStack {
                            GroupSelected()
                                .offset(x: groupSelection == GroupSelection.group ? 0 : -SCREEN_WIDTH)
                            NoticeSelected()
                                .offset(x: groupSelection == GroupSelection.notice ? 0 : SCREEN_WIDTH)
                        }
                        .padding(.bottom, -10)
                    }
                    .isHidden(hidden: isSearchBarFocused)
                }
                .navigationTitle("")
                .navigationBarHidden(true)
                .animation(.spring(), value: groupSelection)
            }
        }
        .overlay(CreateGroupButton())
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
        .isHidden(hidden: isSearchBarFocused || groupSelection == .notice)
    }
}

struct Group_Previews: PreviewProvider {
    static var previews: some View {
        GroupMain()
    }
}
