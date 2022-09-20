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
    
    @Binding private var isShowingRequestButton: Bool
    @Binding private var offset: CGFloat
    
    init(cellId: Int, selectedCellId: Binding<Int>, buttonWidthSize: CGFloat, isShowingRequestButton: Binding<Bool>, offset: Binding<CGFloat>, content: @escaping () -> Content, button: @escaping () -> Button) {
        self.cellId = cellId
        self._selectedCellId = selectedCellId
        self.buttonWidthSize = buttonWidthSize
        self.content = content
        self.button = button
        self._isShowingRequestButton = isShowingRequestButton
        self._offset = offset
    }
    
    
    var body: some View {
        HStack {
            content()
            Spacer()
            button()
                .offset(x: buttonWidthSize)
                .padding(.leading, -1 * buttonWidthSize)
                .disabled(selectedCellId != cellId)
        }
        .offset(x: isShowingRequestButton ? max(-1 * buttonWidthSize, offset) : max(-1 * buttonWidthSize, offset))
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
                            self.offset = min(0, max(-1 * buttonWidthSize + offset, -1 * buttonWidthSize))
                        }
                    }
                }
                .onEnded {
                    let translationWidth = $0.translation.width
                    withAnimation {
                        if !isShowingRequestButton {
                            if translationWidth <= -80 {
                                self.isShowingRequestButton = true
                                self.offset = -1 * buttonWidthSize
                            } else {
                                self.offset = 0
                            }
                        } else {
                            if translationWidth >= 80 {
                                self.isShowingRequestButton = false
                                self.offset = 0
                            } else {
                                self.offset = -1 * buttonWidthSize
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
