//
//  ItemCaution.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI
import Introspect

struct ItemCaution: View {
    
    @ObservedObject var itemVM: ItemViewModel
    @Binding var isActive: Bool
    @State private var viewHeight: CGFloat = .zero
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("사용시 주의해야 할 사항이 있을까요?")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                .padding(.top, 50)
            
            ZStack {
                HeightSetterView(viewHeight: $viewHeight) {
                    Text(itemVM.caution)
                }
                
                TextEditor(text: $itemVM.caution)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    .frame(height: max(100, viewHeight))
                    .padding(3)
                    .overlay{RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray_DEE2E6, lineWidth: 2)}
                
            }
            
            Spacer()
            
            Button {
                Task {
                    isActive = false
                    await itemVM.createProduct()
                }
            } label: {
                RightArrow(isDisabled: itemVM.caution.isEmpty)
            }
        }
        .padding(.horizontal, 20)
        .basicNavigationTitle(title: "물품 등록")
        .introspectTextView { uiTextView in
            uiTextView.isScrollEnabled = false
            uiTextView.textDragInteraction?.isEnabled = false
        }
        .onAppear {
            print("\(isActive.description)")
        }
    }
}

//struct ItemCaution_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemCaution(itemVM: ItemViewModel(), isActive: .constant(true))
//    }
//}
