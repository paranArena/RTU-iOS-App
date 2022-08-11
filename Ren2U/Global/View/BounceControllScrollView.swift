//
//  ScrollBounceControlelr.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/11.
//

import SwiftUI
import Introspect

struct BounceControllScrollView<Content: View>: View {
    
    @Binding var offset: CGFloat
    var content: () -> Content
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            content() 
            .background(GeometryReader {
                // detect Pull-to-refresh
                Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .global).origin.y)
            })
        }
        .introspectScrollView { uiScrollView in
            uiScrollView.bounces = (offset > 0)
        }
        .onPreferenceChange(ViewOffsetKey.self) {
            // offset 값 변경 
            offset = $0
        }
    }
}
