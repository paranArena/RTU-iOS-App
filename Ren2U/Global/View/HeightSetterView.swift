//
//  HeightSetterView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct HeightSetterView<Content: View> : View {
    
    @Binding var viewHeight: CGFloat
    var content: () -> Content
    
    var body: some View {
        content()
            .background(GeometryReader {
                Color.clear.preference(key: ViewHeightKey.self, value: $0.frame(in: .global).height)
            })
            .onPreferenceChange(ViewHeightKey.self) {
                viewHeight = $0
            }
    }
}
