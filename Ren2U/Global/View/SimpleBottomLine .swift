//
//  SimpleBottomLine .swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import SwiftUI

struct SimpleBottomLine: View {
    
    let color: Color
    
    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(color)
        }
    }
}

struct SimpleBottomLine__Previews: PreviewProvider {
    static var previews: some View {
        SimpleBottomLine(color: .gray)
    }
}
