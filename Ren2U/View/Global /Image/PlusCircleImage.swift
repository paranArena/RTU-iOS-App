//
//  PlusButton.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct PlusCircleImage: View {
    var body: some View {
        Image(systemName: "plus.circle")
            .resizable()
            .foregroundColor(.navy_1E2F97)
            .background(Color.BackgroundColor)
            .frame(width: 60, height: 60)
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
    }
}

struct PlusButton_Previews: PreviewProvider {
    static var previews: some View {
        PlusCircleImage()
    }
}
