//
//  Ren2UApp.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

@main
struct Ren2UApp: App {
    
    init() {
        // 네비게이션 바 틴트 컬러 변경 
        Theme.navigationBarColors(tintColor: .label)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthModel())
        }
    }
}
