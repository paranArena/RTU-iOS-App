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
    @State private var offset: CGFloat = 200
    @State private var cancelSelection: CancelSelection = .none
    
    @State private var isShowingModal = true
    let spacing: CGFloat = 10
    
    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            SearchBar(text: $searchText, isFoucsed: $isSearchBarFocused)
                .padding(.horizontal, 20)
            
            Group {
                RentalSelectionButton()
                    .isHidden(hidden: isSearchBarFocused)
                    .background(GeometryReader { gp -> Color in
                        offset = gp.frame(in: .global).maxY + spacing
                        return Color.clear
                    })
                
                ZStack {
                    ForEach(Selection.allCases, id: \.rawValue) { selection in
                        Content(selection: selection)
                            .offset(x: CGFloat((selection.rawValue - self.rentalSelection.rawValue)) * SCREEN_WIDTH)
                    }
                }
                
            }
        }
        .disabled(isShowingModal)
        .overlay(ShadowRectangle())
        .overlay(Modal(isShowingModal: $isShowingModal, text: "예약을 취소하시겠습니까?", callback: {
            isShowingModal = false
            print("예약이 취소되었습니다!")
        }))
        .animation(.spring(), value: rentalSelection)
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            let navigationBarAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.shadowColor = UIColor(Color.BackgroundColor)
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
    
    @ViewBuilder
    private func RentalSelectionButton() -> some View {
        HStack {
            ForEach(RentalTab.Selection.allCases, id: \.rawValue) {  option in
                Button {
                    self.rentalSelection  = option
                } label: {
                    Text(option.title)
                        .frame(maxWidth: .infinity)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 18))
                        .foregroundColor(self.rentalSelection == option ? .navy_1E2F97 : .gray_ADB5BD)
                }
            }
        }
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
        RefreshableScrollView(threshold: offset) {
            VStack {
                ForEach(groupViewModel.rentalItems.indices, id: \.self) { i in
                    NavigationLink(isActive: $groupViewModel.itemViewActive[i]) {
                        Item(itemInfo: groupViewModel.rentalItems[i])
                    } label: {
                        RentalItemHCell(rentalItemInfo: groupViewModel.rentalItems[i])
                    }
                    .isHidden(hidden: isSearchBarFocused && !groupViewModel.rentalItems[i].itemName.contains(searchText))
                }
            }
        }
        .refreshable {
            await groupViewModel.refreshItems()
        }
    }
    
    @ViewBuilder
    private func RentalListSelected() -> some View {
        RefreshableScrollView(threshold: 120) {
            VStack {
                Text("대여목록")
            }
        }
        .refreshable {
            await groupViewModel.refreshItems()
        }
    }
}

struct Rent_Previews: PreviewProvider {
    static var previews: some View {
        RentalTab()
    }
}
