//
//  SimpleLine.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/11.
//

import SwiftUI

struct SimpleLine: View {
    
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(maxWidth: .infinity, maxHeight: 1)
    }
}

//struct SimpleLine_Previews: PreviewProvider {
//    static var previews: some View {
//        SimpleLine()
//    }
//}
