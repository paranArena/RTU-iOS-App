//
//  Ren2UApp.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

@main
struct Ren2UApp: App {
    
    @StateObject var authModel = AuthViewModel()
    @StateObject var groupModel = ClubViewModel()
    @StateObject var tabVM = AmongTabsViewModel()
    
    init() {
        // 네비게이션 바 틴트 컬러 변경 
        Theme.navigationBarColors(tintColor: .label)
        
        // 폰트 이름 출력
//        FontName.printPontNames()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
                .environmentObject(groupModel)
                .environmentObject(tabVM)
        }
    }
}
