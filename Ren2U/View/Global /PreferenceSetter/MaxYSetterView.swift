//
//  MinYSetterView .swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/02.
//

import SwiftUI

struct MaxYSetterView<Content: View>: View {
    
    @Binding var viewMaxY: CGFloat
    var content: () -> Content
    
    
    var body: some View {
        content()
            .background(GeometryReader {
                Color.clear.preference(key: ViewMaxYKey.self, value: $0.frame(in: .global).maxY)
            })
            .onPreferenceChange(ViewMaxYKey.self) {
                viewMaxY = $0
            }
    }
}

//struct MinYSetterView__Previews: PreviewProvider {
//    static var previews: some View {
//        MaxYSetterView()
//    }
//}
