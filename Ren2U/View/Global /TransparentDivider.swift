//
//  CustomDivider.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/28.
//

import SwiftUI

struct TransparentDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color.BackgroundColor)
            .padding(0)
    }
}

struct CustomDivider_Previews: PreviewProvider {
    static var previews: some View {
        TransparentDivider()
    }
}
