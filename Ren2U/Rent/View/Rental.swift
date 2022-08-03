//
//  Rent.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct Rental: View {
    
    @EnvironmentObject var groupModel: GroupModel
    @State private var rentalSelection: RentalSelection = .rentalItem
    @State private var searchText = ""
    @State private var isSearchBarFocused = false
    private let selectionWidth = UIScreen.main.bounds.width / CGFloat(RentalSelection.allCases.count)
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            SearchBar(text: $searchText, isFoucsed: $isSearchBarFocused)
                .padding(.horizontal, 20)
            
            RentalSelectionButton()
            
            ScrollView {
                VStack {
                    ForEach(groupModel.rentalItems.indices) { i in
                        NavigationLink {
                            Text("3")
                        } label: {
                            RentalItemHCell(rentalItemInfo: groupModel.rentalItems[i])
                        }
                    }
                }
            }
                
            
        }
        .animation(.spring(), value: rentalSelection)
    }
    
    @ViewBuilder
    func RentalSelectionButton() -> some View {
        HStack {
            ForEach(RentalSelection.allCases, id: \.self) {  option in
                Button {
                    self.rentalSelection  = option
                } label: {
                    Text(option.title)
                        .frame(width: selectionWidth)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 18))
                        .foregroundColor(self.rentalSelection == option ? .Navy_1E2F97 : .Gray_ADB5BD)
                }

            }
        }
        .padding(.bottom, 20)
    }
}

struct Rent_Previews: PreviewProvider {
    static var previews: some View {
        Rental()
    }
}
