//
//  ShowMapLabel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI

struct GrayRoundedRectangle: View {
    
    let bgColor: Color
    let fgColor: Color
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
            .frame(width: 150, height: 30)
            .foregroundColor(fgColor)
            .background(RoundedCorner(radius: 8, corners: .allCorners).fill(bgColor))
    }
}

//struct ShowMapLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowMapLabel()
//    }
//}
