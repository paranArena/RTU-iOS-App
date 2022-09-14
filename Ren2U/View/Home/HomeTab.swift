//
//  Home.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct HomeTab: View {
    
    var body: some View {
        VStack {
            Text("홈")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(ShadowRectangle())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeTab()
    }
}
