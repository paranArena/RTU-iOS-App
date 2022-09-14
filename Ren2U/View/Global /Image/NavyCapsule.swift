//
//  NavyCapsule.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/13.
//

import SwiftUI

struct NavyCapsule: View {

    let text: String
    var body: some View {
        
        Text(text)
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                Capsule().fill(Color.navy_1E2F97)
            )
            .padding(.horizontal, 10)
    }
}

//struct NavyCapsule_Previews: PreviewProvider {
//    static var previews: some View {
//        NavyCapsule()
//    }
//}
