//
//  Home.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct HomeTab: View {
    
    @State private var offset: CGFloat = 0
    var body: some View {
        ScrollView {
            Text("??")
                .background(GeometryReader { gp -> Color in
                    offset = gp.frame(in: .global).maxY
                    print(offset)
                    return Color.clear
                })
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeTab()
    }
}
