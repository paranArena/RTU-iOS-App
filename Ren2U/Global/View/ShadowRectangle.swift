//
//  ShadowRectangle.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/28.
//

import SwiftUI

struct ShadowRectangle: View {
    var body: some View {
            
        VStack {
            Spacer()
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.Gray_DEE2E6, Color.white]), startPoint: .bottom, endPoint: .top))
                .frame(width: UIScreen.main.bounds.width, height: 10)
                .opacity(0.5)
        }
    }
}

struct ShadowRectangle_Previews: PreviewProvider {
    static var previews: some View {
        ShadowRectangle()
    }
}