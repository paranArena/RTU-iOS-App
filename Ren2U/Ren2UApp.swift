//
//  Ren2UApp.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

@main
struct Ren2UApp: App {
    
    @StateObject var authModel = AuthModel()
    @StateObject var groupModel = GroupModel()
    
    init() {
        // 네비게이션 바 틴트 컬러 변경 
        Theme.navigationBarColors(tintColor: .label)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
                .environmentObject(groupModel)
        }
    }
}
