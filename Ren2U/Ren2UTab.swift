//
//  Ren2UTab.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct Ren2UTab: View {
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
                .foregroundColor(.Navy_1E2F97)
            GroupMain()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("그룹")
                }
            Rent()
                .tabItem {
                    Image(systemName: "rectangle.on.rectangle")
                    Text("대여")
                }
            MyPage()
                .tabItem {
                    Image(systemName: "person")
                    Text("마이페이지")
                }
        }
    }
}

struct Ren2UTab_Previews: PreviewProvider {
    static var previews: some View {
        Ren2UTab()
    }
}
