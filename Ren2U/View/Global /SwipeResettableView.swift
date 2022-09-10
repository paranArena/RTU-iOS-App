//
//  ScrollResetView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/04.
//

import SwiftUI

struct SwipeResettableView<Content: View>: View {
    
    
    @Binding var selectedCellId: Int
    var content: () -> Content
    
    let impossibleId = -999999
    
    @State private var maxY: CGFloat = .zero
    
    var body: some View {
        MaxYSetterView(viewMaxY: $maxY) {
            content()
                .onChange(of: maxY) { _ in
                    if selectedCellId != impossibleId {
                        selectedCellId = impossibleId
                    }
                }
        }
    }
}

//struct ScrollResetView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollResetView()
//    }
//}
