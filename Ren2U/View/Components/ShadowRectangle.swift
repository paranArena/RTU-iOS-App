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
                .fill(LinearGradient(gradient: Gradient(colors: [Color.gray_DEE2E6, Color.BackgroundColor.opacity(0)]), startPoint: .bottom, endPoint: .top))
                .frame(width: UIScreen.main.bounds.width, height: 10)
        }
    }
}

struct ShadowRectangle_Previews: PreviewProvider {
    static var previews: some View {
        ShadowRectangle()
    }
}
