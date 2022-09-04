//
//  WithTwoSlideButton.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/02.
//

import SwiftUI

struct CellWithTwoSlideButton<Content: View>: View {
    
    let okMessage: String
    let cancelMessage: String
    let cellID: Int
    @Binding var selectedID: Int
    var content: () -> Content
    let okCallback: () -> ()
    let cancelCallback: () -> ()
    
    @State private var isShowingRequestButton = false
    @State private var offset: CGFloat = .zero
    
    init(okMessage: String, cancelMessage: String, cellID: Int, selectedID: Binding<Int>, content: @escaping () -> Content, okCallback: @escaping () -> (), cancelCallback: @escaping () -> ()) {
        self.okMessage = okMessage
        self.cancelMessage = cancelMessage
        self.cellID = cellID
        self._selectedID = selectedID
        self.content = content
        self.okCallback = okCallback
        self.cancelCallback = cancelCallback
    }
    
    var body: some View {
        HStack {
            content()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.BackgroundColor)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Button {
                    self.offset = .zero
                    self.isShowingRequestButton = false
                    okCallback()
                } label: {
                    Text(okMessage)
                }
                .frame(width: 80, height: 80)
                .background(Color.navy_1E2F97)
                .foregroundColor(Color.white)
                
                Button {
                    self.offset = .zero
                    self.isShowingRequestButton = false
                    cancelCallback()
                } label: {
                    Text(cancelMessage)
                }
                .frame(width: 80, height: 80)
                .background(Color.red_FF6155)
                .foregroundColor(Color.white)
                .padding(0)
            }
            .offset(x : 180)
            .padding(.leading, -180)
            .disabled(selectedID != cellID)
        }
        .offset(x: isShowingRequestButton ? max(-160, offset) : max(-160, offset))
        .gesture(
            DragGesture()
                .onChanged {
                    selectedID = cellID
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
        .onChange(of: selectedID) { newValue in
            if cellID != newValue {
                withAnimation {
                    self.isShowingRequestButton = false
                    self.offset = 0
                }
            }
        }
    }
}

//struct WithTwoSlideButton_Previews: PreviewProvider {
//    static var previews: some View {
//        WithTwoSlideButton()
//    }
//}
