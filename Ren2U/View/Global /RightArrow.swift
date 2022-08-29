//
//  RightArrow.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//  Navigation Link에서 사용하기 위한 이미지 

import SwiftUI


struct RightArrow: View {
    
    let isDisabled: Bool
    
    var body: some View {
        Image(systemName: "arrow.right.circle.fill")
            .resizable()
            .frame(width: 86, height: 86)
            .foregroundColor(isDisabled ? .gray_E9ECEF : .navy_1E2F97)
    }
}

struct RightArrow_Previews: PreviewProvider {
    static var previews: some View {
        RightArrow(isDisabled: true)
    }
}
