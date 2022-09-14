//
//  ScrollBounceControlelr.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/11.
//

import SwiftUI
import Introspect

struct BounceControllScrollView<Content: View>: View {
    
    let baseOffset: CGFloat
    @Binding var offset: CGFloat
    var content: () -> Content
    
    init(baseOffset: CGFloat, offset: Binding<CGFloat>, content: @escaping () -> Content) {
        self.baseOffset = baseOffset
        self._offset = offset
        self.content = content
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            content()
            .background(GeometryReader {
                Color.clear.preference(key: ViewOffsetKey.self, value: $0.frame(in: .global).origin.y)
            })
            .background(Rectangle().fill(offset > 0 ? Color.clear : Color.clear))
            .onPreferenceChange(ViewOffsetKey.self) { offset = $0 }
        }
        .introspectScrollView { uiScrollView in
            uiScrollView.bounces = (offset <= baseOffset)
        }
    }
}
