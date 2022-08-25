//
//  RentalManagementSelected.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

extension RentalManagementSelected {
    
    enum Selection: Int, CaseIterable {
        case book
        case rental
        case `return`
        
        var title: String {
            switch self {
            case .book:
                return "에약"
            case .rental:
                return "대여"
            case .return:
                return "반납"
            }
        }
    }
}
struct RentalManagementSelected: View {
    
    @State private var selection: Selection = .book
    @State private var hearderSelectionWidth: CGFloat = .zero
    
    var body: some View {
        VStack {
            ButtonRentalSelection()
        }
    }
    
    @ViewBuilder
    private func ButtonRentalSelection() -> some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                ForEach(Selection.allCases, id: \.rawValue) { option in
                    WidthSetterView(viewWidth: $hearderSelectionWidth) {
                        Button {
                            self.selection = option
                        } label: {
                            Text(option.title)
                                .frame(maxWidth: .infinity)
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                                .foregroundColor(self.selection == option ? .navy_1E2F97 : .gray_ADB5BD)
                        }
                    }
                }
            }
            
            HStack {
                Rectangle()
                    .fill(Color.navy_1E2F97)
                    .frame(width: hearderSelectionWidth * 0.6, height: 2)
                    .padding(.leading, hearderSelectionWidth * CGFloat(selection.rawValue) + hearderSelectionWidth * 0.2)
                    .animation(.spring(), value: selection)
                Spacer()
            }
        }
    }
}

struct RentalManagementSelected_Previews: PreviewProvider {
    static var previews: some View {
        RentalManagementSelected()
    }
}
