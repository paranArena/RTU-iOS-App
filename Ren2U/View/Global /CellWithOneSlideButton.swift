//
//  CellWithOneSlideButton.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/08.
//

import SwiftUI

struct CellWithOneSlideButton<Content: View> : View {
    
    let okMessage: String
    let cellID: Int
    @Binding var selectedID: Int
    var content: () -> Content
    let callback: () -> ()
    
    @State private var isShowingRequestButton = false
    @State private var offset: CGFloat = .zero
    
    init(okMessage: String, cellID: Int, selectedID: Binding<Int>, content: @escaping () -> Content, callback: @escaping () -> ()) {
        self.okMessage = okMessage
        self.cellID = cellID
        self._selectedID = selectedID
        self.content = content
        self.callback = callback
    }
    var body: some View {
        VStack {
            HStack {
                content()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.BackgroundColor)
                    .padding(.leading)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 0) {
                    Button {
                        callback()
                    } label: {
                        Text(okMessage)
                    }
                    .frame(width: 80, height: 80)
                    .background(Color.red_EB1808)
                    .foregroundColor(Color.white)
                }
                .offset(x : 80)
                .padding(.leading, -80)
                .disabled(selectedID != cellID)
            }
            .offset(x: isShowingRequestButton ? max(-80, offset) : max(-80, offset))
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
                                self.offset = min(0, max(-80 + offset, -80))
                            }
                        }
                    }
                    .onEnded {
                        let translationWidth = $0.translation.width
                        withAnimation {
                            if !isShowingRequestButton {
                                if translationWidth <= -80 {
                                    self.isShowingRequestButton = true
                                    self.offset = -80
                                } else {
                                    self.offset = 0
                                }
                            } else {
                                if translationWidth >= 80 {
                                    self.isShowingRequestButton = false
                                    self.offset = 0
                                } else {
                                    self.offset = -80
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
            
            
            Divider()
        }
    }
}

//struct CellWithOneSlideButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CellWithOneSlideButton()
//    }
//}
