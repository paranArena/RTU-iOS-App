//
//  Ren2UTab.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

enum TabSelection: Int, CaseIterable {
    case home
    case group
    case rent
    case myPage
}

struct Ren2UTab: View {
    
    @EnvironmentObject var groupModel: GroupModel
    @State private var title = ""
    @State private var tabSelection: Int = TabSelection.home.rawValue
    
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor(Color.BackgroundColor)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $tabSelection) {
                Home()
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈")
                    }
                    .overlay(ShadowRectangle())
                    .onAppear {
                        self.title = "Home"
                    }
                    .tag(TabSelection.home.rawValue)
                    

                GroupMain(tabSelection: $tabSelection)
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("그룹")
                    }
                    .tag(TabSelection.group.rawValue)
                    .overlay(ShadowRectangle())
                    .onAppear {
                        self.title = ""
                    }
                
                
                Rental()
                    .tabItem {
                        Image(systemName: "rectangle.on.rectangle")
                        Text("대여")
                    }
                    .overlay(ShadowRectangle())
                    .onAppear {
                        self.title = "Rent"
                    }
                    .tag(TabSelection.rent.rawValue)

                MyPage()
                    .tabItem {
                        Image(systemName: "person")
                        Text("마이페이지")
                    }
                    .overlay(ShadowRectangle())
                    .onAppear {
                        self.title = "MyPage"
                    }
                    .tag(TabSelection.myPage.rawValue)
            }
            .navigationTitle(title)
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
}

struct Ren2UTab_Previews: PreviewProvider {
    static var previews: some View {
        Ren2UTab()
    }
}
