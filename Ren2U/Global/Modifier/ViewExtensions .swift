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

//  Corner Radius 특정 위치에만 적용하기
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//  MARK: 테두리만 있는 캡슐
extension View {
    func capsuleStrokeAndForegroundColor(color: Color) -> some View {
        self
            .foregroundColor(color)
            .background(Capsule().stroke(color, lineWidth: 1))
    }
}

//  MARK: 기본 타이틀 제어
extension View {
    func basicNavigationTitle(title: String) -> some View {
        self
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                }
            }
    }
}

//  MARK: TAB VIEW 숨긴 후 SAFE AREA만큼 띄우기 (스크롤에서 사용)
extension View {
    func avoidSafeArea() -> some View {
        self
            .padding(.bottom, SAFE_AREA_BOTTOM_HEIGHT)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.BackgroundColor)
                    .frame(height: SAFE_AREA_BOTTOM_HEIGHT)
            }
            .ignoresSafeArea(.all, edges: .bottom)
    }
}
