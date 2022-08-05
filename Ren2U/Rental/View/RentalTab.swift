//
//  Rent.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import HidableTabView

struct RentalTab: View {
    
    @EnvironmentObject var groupViewModel: GroupViewModel
    @State private var rentalSelection: Selection = .rentalItem
    @State private var searchText = ""
    @State private var isSearchBarFocused = false
    
    private let selectionWidth = UIScreen.main.bounds.width / CGFloat(Selection.allCases.count)
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            SearchBar(text: $searchText, isFoucsed: $isSearchBarFocused)
                .padding(.horizontal, 20)
            
            Group {
                RentalSelectionButton()
                
                ZStack {
                    ForEach(Selection.allCases, id: \.rawValue) { selection in
                        Content(selection: selection)
                            .offset(x: CGFloat((selection.rawValue - self.rentalSelection.rawValue)) * SCREEN_WIDTH)
                    }
                }
                .padding(.bottom, -10)
            }
        }
        .overlay(ShadowRectangle())
        .showTabBar(animated: false)
        .animation(.spring(), value: rentalSelection)
        .navigationTitle("")
        .navigationBarHidden(true)

    }
    
    @ViewBuilder
    private func RentalSelectionButton() -> some View {
        HStack {
            ForEach(RentalTab.Selection.allCases, id: \.rawValue) {  option in
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
    private func Content(selection: RentalTab.Selection) -> some View {
        switch selection {
        case .rentalItem:
            self.RentalItemSelected()
        case .rentalList:
            self.RentalListSelected()
        }
    }
    
    @ViewBuilder
    private func RentalItemSelected() -> some View {
        ScrollView {
            VStack {
                ForEach(groupViewModel.rentalItems.indices) { i in
                    NavigationLink(isActive: $groupViewModel.itemViewActive[i]) {
                        Item(itemInfo: groupViewModel.rentalItems[i])
                    } label: {
                        RentalItemHCell(rentalItemInfo: groupViewModel.rentalItems[i])
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func RentalListSelected() -> some View {
        Text("대여목록")
    }
    
}

struct Rent_Previews: PreviewProvider {
    static var previews: some View {
        RentalTab()
    }
}
