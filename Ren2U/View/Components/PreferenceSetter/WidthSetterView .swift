//
//  WidthSetterView .swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct WidthSetterView<Content: View> : View {
    
    @Binding var viewWidth: CGFloat
    var content: () -> Content
    
    @MainActor
    var body: some View {
        content()
            .background(GeometryReader {
                Color.clear.preference(key: ViewWidthKey.self, value: $0.frame(in: .global).width)
            })
            .onPreferenceChange(ViewWidthKey.self) { newValue in
                viewWidth = newValue
            }
    }
}

//struct WidthSetterView_Previews: PreviewProvider {
//    static var previews: some View {
//        WidthSetterView()
//    }
//}
