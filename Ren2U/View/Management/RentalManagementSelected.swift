//
//  RentalManagementSelected.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

struct RentalManagementSelected: View {
    
    @ObservedObject var manageVM: ManagementViewModel
    @State private var filter: RentalStatus = .wait
    @State private var hearderSelectionWidth: CGFloat = .zero
    
    var body: some View {
        VStack {
            ButtonRentalSelection()
            
            ScrollView {
                BookList()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .avoidSafeArea()
    }
    
    @ViewBuilder
    private func ButtonRentalSelection() -> some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                ForEach(RentalStatus.allCases, id: \.rawValue) { option in
                    WidthSetterView(viewWidth: $hearderSelectionWidth) {
                        Button {
                            self.filter = option
                        } label: {
                            Text(option.title)
                                .frame(maxWidth: .infinity)
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                                .foregroundColor(self.filter == option ? .navy_1E2F97 : .gray_ADB5BD)
                        }
                    }
                }
            }
            
            HStack {
                Rectangle()
                    .fill(Color.navy_1E2F97)
                    .frame(width: hearderSelectionWidth * 0.6, height: 2)
                    .padding(.leading, hearderSelectionWidth * CGFloat(filter.value) + hearderSelectionWidth * 0.2)
                    .animation(.spring(), value: filter)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func BookList() -> some View {
        VStack {
            ForEach(manageVM.rentals.indices, id: \.self) { i in
                Group {
                    BookCell(data: manageVM.rentals[i])
                        .padding(.horizontal)
                    
                    Divider()
                }
                .isHidden(hidden: manageVM.rentals[i].rentalInfo.rentalStatus != filter.rawValue)
            }
        }
    }
}

//struct RentalManagementSelected_Previews: PreviewProvider {
//    static var previews: some View {
//        RentalManagementSelected()
//    }
//}
