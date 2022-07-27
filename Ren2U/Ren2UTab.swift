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
    @State private var tabSelection: TabSelection?
    @State private var searchText = ""
    @State private var title = ""
    @State private var isShowingTitle = true
    
    init() {
        // 탭바 그림자
        let image =
            UIImage.gradientImageWithBounds(bounds: CGRect(x: 0, y: 0, width: UIScreen.main.scale, height: 8), colors: [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.1).cgColor
            ])
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemGray6
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = image
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            TabView() {
                Home()
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈")
                    }
                    .onAppear {
                        self.title = "Home"
                        self.isShowingTitle = true
                        self.tabSelection = .home
                    }

                GroupMain()
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("그룹")
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear {
                        self.title = "Group"
                        self.isShowingTitle = true
                        self.tabSelection = .group
                    }
                
                
                Rent()
                    .tabItem {
                        Image(systemName: "rectangle.on.rectangle")
                        Text("대여")
                    }
                    .onAppear {
                        self.title = "Rent"
                        self.isShowingTitle = true
                        self.tabSelection = .rent
                    }

                MyPage()
                    .tabItem {
                        Image(systemName: "person")
                        Text("마이페이지")
                    }
                    .onAppear {
                        self.title = "MyPage"
                        self.isShowingTitle = true
                        self.tabSelection = .myPage
                    }
            }
            .navigationTitle(title)
            .navigationBarHidden(!isShowingTitle)
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(.Navy_1E2F97)
            .foregroundColor(.LabelColor)
            .toolbar(content: {
                ToolbarItemGroup(placement: .principal) {
                    switch tabSelection {
                    case .home, .group, .none:
                        SearchBar()
                    case .rent, .myPage:
                        EmptyView()
                    }
                }
            })
            .onAppear {
                groupModel.fetchNotices()
                groupModel.fetchRentalItems()
            }
        }
    }
    
    @ViewBuilder
    func SearchBar() -> some View {
        
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.Gray_DEE2E6)
                TextField("I`ll Ren2U", text: $searchText)
            }
            .padding(5)
            .overlay {
                Capsule()
                    .stroke(Color.Gray_DEE2E6, lineWidth: 2)
            }
            
            Image(systemName: "bell")
        }
    }
    
    @ViewBuilder
    func EmptyView() -> some View {
        
        HStack {
            Text("툴바 예정")
        }
    }
   
}

struct Ren2UTab_Previews: PreviewProvider {
    static var previews: some View {
        Ren2UTab()
    }
}
