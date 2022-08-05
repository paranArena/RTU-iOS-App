//
//  Rent.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import HidableTabView

struct Rental: View {
    
    @EnvironmentObject var groupModel: GroupViewModel
    @State private var rentalSelection: RentalSelection = .rentalItem
    @State private var searchText = ""
    @State private var isSearchBarFocused = false
    private let selectionWidth = UIScreen.main.bounds.width / CGFloat(RentalSelection.allCases.count)
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            SearchBar(text: $searchText, isFoucsed: $isSearchBarFocused)
                .padding(.horizontal, 20)
            
            Group {
                RentalSelectionButton()
                
                ZStack {
                    RentalItemSelected()
                        .offset(x: rentalSelection == .rentalItem ? 0 : -SCREEN_WIDTH)
                    RentalListSelected()
                        .offset(x: rentalSelection == .rentalList ? 0 : SCREEN_WIDTH)
                }
                .padding(.bottom, -10)
            }
        }
        .showTabBar(animated: false)
        .animation(.spring(), value: rentalSelection)
        .navigationTitle("")
        .navigationBarHidden(true)

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
    
    @ViewBuilder
    func RentalItemSelected() -> some View {
        ScrollView {
            VStack {
                ForEach(groupModel.rentalItems.indices) { i in
                    NavigationLink(isActive: $groupModel.itemViewActive[i]) {
                        Item(itemInfo: groupModel.rentalItems[i])
                    } label: {
                        RentalItemHCell(rentalItemInfo: groupModel.rentalItems[i])
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func RentalListSelected() -> some View {
        Text("대여목록")
    }
}

struct Rent_Previews: PreviewProvider {
    static var previews: some View {
        Rental()
    }
}
