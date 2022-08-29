//
//  Modal .swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import SwiftUI

extension Modal {
    enum ButtonOption {
        case none
        case yes
        case no
    }
}

struct Modal: View {
    
    @Binding var isShowingModal: Bool
    let text: String
    let callback: () -> ()
    
    @State var buttonOption: ButtonOption = .none
    
    var body: some View {
        VStack {
            Text(text)
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 16))
            
            HStack {
                Text("예")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .frame(width: 90, height: 36)
                    .foregroundColor(self.buttonOption == .yes ? Color.white : Color.navy_1E2F97)
                    .background(Capsule().fill(self.buttonOption == .yes ? Color.navy_1E2F97 : Color.white))
                    .background(Capsule().stroke(Color.navy_1E2F97, lineWidth: 2))
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if abs(value.translation.height) < 50 && abs(value.translation.width) < 50  {
                                    self.buttonOption = .yes
                                } else {
                                    self.buttonOption = .none
                                }
                            }
                            .onEnded { value in
                                if self.buttonOption != .none {
                                    callback()
                                    self.buttonOption = .none
                                    self.isShowingModal.toggle()
                                }
                            }
                    )
                
                Text("아니오")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .frame(width: 90, height: 36)
                    .foregroundColor(self.buttonOption == .no ? Color.white : Color.navy_1E2F97)
                    .background(Capsule().fill(self.buttonOption == .no ? Color.navy_1E2F97 : Color.white))
                    .background(Capsule().stroke(Color.navy_1E2F97, lineWidth: 2))
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if abs(value.translation.height) < 50 && abs(value.translation.width) < 50  {
                                    self.buttonOption = .no
                                } else {
                                    self.buttonOption = .none
                                }
                            }
                            .onEnded { value in
                                if self.buttonOption != .none {
                                    self.buttonOption = .none
                                    self.isShowingModal.toggle()
                                }
                            }
                    )
            }
        }
        .frame(width: 320, height: 160)
        .background(Color.gray_F8F9FA)
        .cornerRadius(15)
        .clipped()
        .shadow(color: Color.gray_ADB5BD, radius: 5, x: 0, y: 0)
        .overlay(alignment: .topTrailing, content: {
            Button {
                isShowingModal.toggle()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(Color.black)
            }
            .padding(.all, 10)
        })
        .isHidden(hidden: !isShowingModal)
        
    }
}

//struct Modal_Previews: PreviewProvider {
//    static var previews: some View {
//        Modal()
//    }
//}
