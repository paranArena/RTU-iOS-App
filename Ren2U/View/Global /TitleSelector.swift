//
//  Header.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/23.
//

import SwiftUI

protocol Title {
    var title: [String] { get set }
    
    func getTitleOffset(title: String) -> Int
    func getTitleColor(title: String, index: Int) -> Color
}

struct TitleSelector: View {
    
    let titles: Title
    @Binding var selectedTitle: String
    @State private var titleWidth: CGFloat = .zero
  
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                ForEach(titles.title.indices, id: \.self) { i in
                    WidthSetterView(viewWidth: $titleWidth) {
                        Button {
                            self.selectedTitle = titles.title[i]
                        } label: {
                            Text(titles.title[i])
                                .frame(maxWidth: .infinity)
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                                .foregroundColor(titles.title[i] == selectedTitle ? Color.navy_1E2F97 : Color.gray_ADB5BD)
                        }
                    }
                }
            }

            HStack {
                Rectangle()
                    .fill(Color.navy_1E2F97)
                    .frame(width: titleWidth * 0.6, height: 2)
                    .padding(.leading, titleWidth * CGFloat(titles.getTitleOffset(title: selectedTitle)) + titleWidth * 0.2)
                    .animation(.spring(), value: selectedTitle)
                Spacer()
            }
        }
    }
}

//struct Header_Previews: PreviewProvider {
//    static var previews: some View {
//        TitleSelector()
//    }
//}
