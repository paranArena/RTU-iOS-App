//
//  Ren2UTab.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import HidableTabView



struct Ren2UTab: View {
    
    @EnvironmentObject var groupViewModel: GroupViewModel
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
            groupViewModel.fetchJoinedGroups()
            groupViewModel.fetchNotices()
            groupViewModel.fetchRentalItems()
            groupViewModel.getLikesGroups()
        }
    }
    
    @ViewBuilder
    private func Content(selection: Selection) -> some View {
        switch selection {
        case .home:
            HomeTab()
        case .group:
            GroupTab(tabSelection: $tabSelection)
        case .rent:
            RentalTab()
        case .myPage:
            MyPageTab()
        }
    }
    
    @ViewBuilder
    private func TabItem(selection: Selection) -> some View {
        switch selection {
        case .home:
            Label {
                Text(Selection.home.title)
            } icon: {
                Image(systemName: Selection.home.imageSource)
            }
        case .group:
            Label {
                Text(Selection.group.title)
            } icon: {
                Image(systemName: Selection.group.imageSource)
            }
        case .rent:
            Label {
                Text(Selection.rent.title)
            } icon: {
                Image(systemName: Selection.rent.imageSource)
            }
        case .myPage:
            Label {
                Text(Selection.myPage.title)
            } icon: {
                Image(systemName: Selection.myPage.imageSource)
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
        
        var title: String {
            switch self {
            case .home:
                return "홈"
            case .group:
                return "그룹"
            case .rent:
                return "대여"
            case .myPage:
                return "마이페이지"
            }
        }
        var imageSource: String {
            switch self {
            case .home:
                return "house"
            case .group:
                return "person.2"
            case .rent:
                return "rectangle.on.rectangle"
            case .myPage:
                return "person"
            }
        }
    }
}

struct Ren2UTab_Previews: PreviewProvider {
    static var previews: some View {
        Ren2UTab()
    }
}
