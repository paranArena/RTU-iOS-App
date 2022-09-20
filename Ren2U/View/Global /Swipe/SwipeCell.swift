//
//  SwipeCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/19.
//

import SwiftUI

struct SwipeCell<Content: View, Button: View> : View {
    
    let cellId: Int
    @Binding var selectedCellId: Int
    let content: () -> Content
    let button: () -> Button
    let buttonWidthSize: CGFloat
    
    @State private var isShowingRequestButton = false
    @State private var offset: CGFloat = .zero
    
    init(cellId: Int, selectedCellId: Binding<Int>, buttonWidthSize: CGFloat, content: @escaping () -> Content, button: @escaping () -> Button) {
        self.cellId = cellId
        self._selectedCellId = selectedCellId
        self.buttonWidthSize = buttonWidthSize
        self.content = content
        self.button = button
    }
    
    
    var body: some View {
        VStack {
            HStack {
                content()
                Spacer()
                button() 
            }
        }
        .gesture(
            DragGesture()
                .onChanged {
                    selectedCellId = cellId
                    let translationWidth = $0.translation.width
                    
                    withAnimation {
                        self.offset = translationWidth
                        if !self.isShowingRequestButton {
                            self.offset = min(offset, 0)
                        } else {
                            self.offset = min(0, max(-160 + offset, -160))
                        }
                    }
                }
                .onEnded {
                    let translationWidth = $0.translation.width
                    withAnimation {
                        if !isShowingRequestButton {
                            if translationWidth <= -80 {
                                self.isShowingRequestButton = true
                                self.offset = -160
                            } else {
                                self.offset = 0
                            }
                        } else {
                            if translationWidth >= 80 {
                                self.isShowingRequestButton = false
                                self.offset = 0
                            } else {
                                self.offset = -160
                            }
                        }
                    }
                }
        )
        .onChange(of: selectedCellId) { newValue in
            if cellId != newValue {
                withAnimation {
                    self.isShowingRequestButton = false
                    self.offset = 0
                }
            }
        }
    }
}

//struct SwipeCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SwipeCell()
//    }
//}
