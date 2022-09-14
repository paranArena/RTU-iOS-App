//
//  SearchBar.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/28.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    @Binding var isFoucsed: Bool
    @FocusState private var focused: Bool?
    
    var body: some View {
        
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 5)
                    .foregroundColor(Color.gray_DEE2E6)
                TextField("I`ll Ren 2 U!", text: $text)
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
                    .focused($focused, equals: true)
            }
            .padding(8)
            .onTapGesture {
                focused = true
                isFoucsed = true
            }
            .overlay{
                Capsule()
                    .strokeBorder(Color.gray_DEE2E6, lineWidth: 2)
            }
            
            Button {
                focused = nil
                isFoucsed = false
                text = "" 
            } label: {
                Text("취소")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
            }
            .isHidden(hidden: !isFoucsed)
            .frame(minWidth: 30)
        }
    }
}

//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar()
//    }
//}
