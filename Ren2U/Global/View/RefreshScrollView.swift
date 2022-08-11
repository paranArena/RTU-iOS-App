//
//  RefreshScrollView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/11.
//

import SwiftUI
import AVFoundation

struct RefreshScrollView<Content: View>: View {
    
    var content: () -> Content
    
    @Environment(\.refresh) private var refresh   // << refreshable injected !!
    @State private var isRefreshing = false
    let threshold: CGFloat = -250
    
    var body: some View {
        ZStack(alignment: .top) {
            if isRefreshing {
                ProgressView()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                content()
                    .background(GeometryReader {
                        // detect Pull-to-refresh
                        Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .global).origin.y)
                    })
                    .padding(.top, isRefreshing ? 120 : 0)
            }
            .allowsHitTesting(!isRefreshing)
            .onPreferenceChange(ViewOffsetKey.self) {
                if $0 < threshold && !isRefreshing {
                    print($0)
                    simpleSuccess() // 핸드폰에 진동 주기
                    Task {
                        isRefreshing = true
                        await refresh?()
                        withAnimation {
                            isRefreshing = false
                        }
                    }
                }
            }
        }
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
