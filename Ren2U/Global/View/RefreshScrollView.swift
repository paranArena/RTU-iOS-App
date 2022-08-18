//
//  RefreshScrollView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/11.
//

import SwiftUI
import AVFoundation

struct RefreshScrollView<Content: View>: View {
    
    let threshold: CGFloat
    var content: () -> Content
    
    @Environment(\.refresh) private var refresh   // << refreshable injected !!
    @State private var isRefreshing = false
    @State private var isTouched = false
    
    
    var body: some View {
        ZStack(alignment: .top) {
            if isRefreshing {
                ProgressView()
            }
            
            
            ScrollView(.vertical, showsIndicators: false) {
                content()
                    .background(GeometryReader {
                        // detect Pull-to-refresh
                        Color.clear.preference(key: ViewOffsetKey.self, value: $0.frame(in: .global).minY)
                    })
                    .padding(.top, isRefreshing ? 50 : 0)
            }
            .simultaneousGesture(
                DragGesture()
                    .onChanged({ _ in
                        isTouched = true
                    })
            )
            .allowsHitTesting(!isRefreshing)
            .onPreferenceChange(ViewOffsetKey.self) {
                if $0 > (threshold+50) && !isRefreshing && isTouched {
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


public struct ViewOffsetKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
