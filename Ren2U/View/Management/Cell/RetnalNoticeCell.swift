//
//  RetnalNoticeCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI
import Kingfisher

struct RetnalNoticeCell: View {
    
    @State private var isShowingRequestButton = false
    @State private var offset: CGSize = .zero
    
    var body: some View {
        HStack {
            KFImage(URL(string: "")!).onFailure { err in
                print(err.errorDescription ?? "KFImage err")
            }
            .resizable()
            .frame(width: 80, height: 80)
            .cornerRadius(15)
            .isHidden(hidden: isShowingRequestButton)
            
            
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Button {
                    
                } label: {
                    Text("확인")
                }
                .frame(width: 80, height: 80)
                .background(Color.navy_1E2F97)
                .foregroundColor(Color.white)
                
                Button {
                    
                } label: {
                    Text("거부")
                }
                .frame(width: 80, height: 80)
                .background(Color.red_FF6155)
                .foregroundColor(Color.white)
            }
            .offset(x : 180)
            .padding(.leading, -180)
            
        }
        .offset(x: isShowingRequestButton ? -160 : 0)
        .animation(.spring(), value: isShowingRequestButton)
        .gesture(
            DragGesture()
                .onChanged {
                    self.offset = $0.translation
                }
                .onEnded {
                    if $0.translation.width < -50 {
                        self.isShowingRequestButton = true
                    } else if $0.translation.width > 50 {
                        self.isShowingRequestButton = false
                    }
                }
        )
    }
    
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter.string(from: Date.now)
    }
}

//struct RetnalNoticeCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RetnalNoticeCell()
//    }
//}
