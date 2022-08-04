//
//  Ren2UTab.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import HidableTabView

enum TabSelection: Int, CaseIterable {
    case home
    case group
    case rent
    case myPage
}

struct Ren2UTab: View {
    
    @EnvironmentObject var groupModel: GroupModel
    @State private var tabSelection: Int = TabSelection.home.rawValue
    
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor(Color.BackgroundColor)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            
            
            NavigationView {
                Home()
            }
            .tag(TabSelection.home.rawValue)
            .tabItem {
                Image(systemName: "house")
                Text("홈")
            }
                

            NavigationView {
                GroupMain(tabSelection: $tabSelection)
            }
            .tag(TabSelection.group.rawValue)
            .tabItem {
                Image(systemName: "person.2")
                Text("그룹")
            }
            
            
            NavigationView {
                Rental()
            }
            .tag(TabSelection.rent.rawValue)
            .tabItem {
                Image(systemName: "rectangle.on.rectangle")
                Text("대여")
            }

            NavigationView {
                MyPage()
            }
            .tag(TabSelection.myPage.rawValue)
            .tabItem {
                Image(systemName: "person")
                Text("마이페이지")
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
}

struct Ren2UTab_Previews: PreviewProvider {
    static var previews: some View {
        Ren2UTab()
    }
}
