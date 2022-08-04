//
//  Ren2UTab.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import HidableTabView



struct Ren2UTab: View {
    
    @EnvironmentObject var groupModel: GroupModel
    @State private var tabSelection: Int = Selection.home.rawValue
    
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor(Color.BackgroundColor)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            ForEach(Selection.allCases, id: \.rawValue) { selection in
                NavigationView {
                    Content(selection: selection)
                }
                .tag(selection.rawValue)
                .tabItem {
                    TabItem(selection: selection)
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .accentColor(.Navy_1E2F97)
        .foregroundColor(.LabelColor)
        .onAppear {
            groupModel.fetchJoinedGroups()
            groupModel.fetchNotices()
            groupModel.fetchRentalItems()
        }
    }
    
    @ViewBuilder
    private func Content(selection: Selection) -> some View {
        switch selection {
        case .home:
            Home()
        case .group:
            GroupMain(tabSelection: $tabSelection)
        case .rent:
            Rental()
        case .myPage:
            MyPage()
        }
    }
    
    @ViewBuilder
    private func TabItem(selection: Selection) -> some View {
        switch selection {
        case .home:
            Label {
                Text("홈")
            } icon: {
                Image(systemName: "house")
            }
        case .group:
            Label {
                Text("그룹")
            } icon: {
                Image(systemName: "person.2")
            }
        case .rent:
            Label {
                Text("그룹")
            } icon: {
                Image(systemName: "rectangle.on.rectangle")
            }
        case .myPage:
            Label {
                Text("마이페이지")
            } icon: {
                Image(systemName: "person")
            }
        }
    }
}

extension Ren2UTab {
    enum Selection: Int, CaseIterable {
        case home
        case group
        case rent
        case myPage
    }
}

struct Ren2UTab_Previews: PreviewProvider {
    static var previews: some View {
        Ren2UTab()
    }
}
