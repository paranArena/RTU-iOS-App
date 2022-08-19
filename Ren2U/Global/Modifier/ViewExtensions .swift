//
//  ViewExtension .swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/19.
//

import Foundation
import HidableTabView
import SwiftUI

// View 숨기기
extension View {
    @ViewBuilder
    func isHidden(hidden: Bool) -> some View {
        if hidden {}
        else { self }
    }
}

// 임시로 네비게이션바 투명하게 하기
extension View {
    @ViewBuilder
    func transparentNavigationBar() -> some View {
        self
            .onAppear {
                let navigationBarAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
                navigationBarAppearance.configureWithTransparentBackground()
                UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            }
            .onDisappear {
                let navigationBarAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
                navigationBarAppearance.configureWithOpaqueBackground()
                navigationBarAppearance.shadowColor = UIColor(Color.BackgroundColor)
                UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            }
    }
}

// Tabbar hide
extension View {
    
    @ViewBuilder
    func controllTabbar(_ isPresented: Bool) -> some View {
        self
            .onChange(of: isPresented) { newValue in
                if newValue {
                    UITabBar.hideTabBar(animated: false)
                } else {
                    UITabBar.showTabBar(animated: false)
                }
            }
    }
}
