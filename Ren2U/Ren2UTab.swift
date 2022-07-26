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
            TabView(selection: $tabSelection) {
                Home()
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈")
                    }
                    .tag(TabSelection.home)

                GroupMain()
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("그룹")
                    }
                    .tag(TabSelection.group)
                Rent()
                    .tabItem {
                        Image(systemName: "rectangle.on.rectangle")
                        Text("대여")
                    }
                    .tag(TabSelection.rent)
                MyPage()
                    .tabItem {
                        Image(systemName: "person")
                        Text("마이페이지")
                    }
                    .tag(TabSelection.myPage)
            }
            .navigationTitle("Hello")
            .navigationBarHidden(true)
            .accentColor(.Navy_1E2F97)
            .foregroundColor(.LabelColor)
            .onAppear {
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
