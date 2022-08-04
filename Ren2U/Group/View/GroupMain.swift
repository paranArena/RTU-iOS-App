//
//  Group.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import HidableTabView

struct GroupMain: View {
    
    @State private var groupSelection: Selection = .group
    @State private var text = ""
    @State private var isSearchBarFocused = false
    @Binding var tabSelection: Int 
    @EnvironmentObject var groupModel: GroupModel
    private let selectionWidth = UIScreen.main.bounds.width / CGFloat(Selection.allCases.count)
    
    var body: some View {
        // horizontal padding 주지 말것! 즐겨찾기 이미지를 좌우 폭에 못 맞추게 된다.
        
        VStack(alignment: .center, spacing: 10) {
            SearchBar(text: $text, isFoucsed: $isSearchBarFocused)
                .padding(.horizontal, 20)
            
            Search(tabSelection: $tabSelection)
                .padding(.bottom, -10)
                .isHidden(hidden: !isSearchBarFocused)
            
            Group {
                GroupSelectionButton()
                ZStack {
                    GroupSelected(tabSelection: $tabSelection)
                        .overlay(CreateGroupButton())
                        .offset(x: groupSelection == Selection.group ? 0 : -SCREEN_WIDTH)
                    NoticeSelected()
                        .offset(x: groupSelection == Selection.notice ? 0 : SCREEN_WIDTH)
                }
                .overlay(ShadowRectangle())
                .padding(.bottom, -10)
            }
            .isHidden(hidden: isSearchBarFocused)
        }
        .showTabBar(animated: false)
        .navigationTitle("")
        .navigationBarHidden(true)
        .animation(.spring(), value: groupSelection)
    }
    
    @ViewBuilder
    func GroupSelectionButton() -> some View {
        HStack {
            ForEach(Selection.allCases, id: \.self) {  option in
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

extension GroupMain {
    enum Selection: Int, CaseIterable {
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
}



//struct Group_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupMain()
//    }
//}
