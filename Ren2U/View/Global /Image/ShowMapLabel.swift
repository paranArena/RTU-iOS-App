//
//  ShowMapLabel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI

struct ShowMapLabel: View {
    
    let bgColor: Color
    let fgColor: Color
    
    var body: some View {
        Text("지도에서 장소 표시")
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
