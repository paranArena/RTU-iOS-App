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
    let spacing: CGFloat = 10
    
    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            SearchBar(text: $searchText, isFoucsed: $isSearchBarFocused)
                .padding(.horizontal, 20)
            
            Group {
                RentalSelectionButton()
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
                .padding(.bottom, -10)
            }
        }
        .overlay(ShadowRectangle())
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
                        .foregroundColor(self.rentalSelection == option ? .Navy_1E2F97 : .Gray_ADB5BD)
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
        RefreshScrollView(threshold: offset) {
            VStack {
                ForEach(groupViewModel.rentalItems.indices, id: \.self) { i in
                    NavigationLink(isActive: $groupViewModel.itemViewActive[i]) {
                        Item(itemInfo: groupViewModel.rentalItems[i])
                    } label: {
                        RentalItemHCell(rentalItemInfo: groupViewModel.rentalItems[i])
                    }
                }
            }
        }
        .refreshable {
            await groupViewModel.refreshItems()
        }
    }
    
    @ViewBuilder
    private func RentalListSelected() -> some View {
        RefreshScrollView(threshold: 120) {
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
