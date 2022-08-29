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
        .disabled(cancelSelection != .default)
        .overlay(ShadowRectangle())
        .overlay(ModalRentalCancel())
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
        RefreshScrollView(threshold: offset) {
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
        RefreshScrollView(threshold: 120) {
            VStack {
                Text("대여목록")
            }
        }
        .refreshable {
            await groupViewModel.refreshItems()
        }
    }
    
    @ViewBuilder
    private func ModalRentalCancel() -> some View {
        VStack(alignment: .center, spacing: 20) {
            Text("예약을 취소하시겠습니까?")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 16))
            
            HStack {
                Text("예")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .frame(width: 90, height: 36)
                    .foregroundColor(self.cancelSelection == .yes ? Color.white : Color.navy_1E2F97)
                    .background(Capsule().fill(self.cancelSelection == .yes ? Color.navy_1E2F97 : Color.white))
                    .background(Capsule().stroke(Color.navy_1E2F97, lineWidth: 2))
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                self.cancelSelection = .yes
                            }
                            .onEnded { _ in
                                self.cancelSelection = .default
                            }
                    )
                
                Text("아니오")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .frame(width: 90, height: 36)
                    .foregroundColor(self.cancelSelection == .no ? Color.white : Color.navy_1E2F97)
                    .background(Capsule().fill(self.cancelSelection == .no ? Color.navy_1E2F97 : Color.white))
                    .background(Capsule().stroke(Color.navy_1E2F97, lineWidth: 2))
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                self.cancelSelection = .no
                            }
                            .onEnded { _ in
                                self.cancelSelection = .default
                            }
                    )
            }
        }
        .frame(width: 320, height: 160)
        .background(Color.gray_F8F9FA)
        .cornerRadius(15)
        .clipped()
        .shadow(color: Color.gray_ADB5BD, radius: 5, x: 0, y: 0)
        .overlay(
            VStack {
                HStack {
                    Spacer()
                    Button {
                        self.cancelSelection = .default
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color.black)
                    }
                    .padding(.all, 10)
                }
                Spacer()
            }
        )
        .isHidden(hidden: cancelSelection == .default)
    }
}

struct Rent_Previews: PreviewProvider {
    static var previews: some View {
        RentalTab()
    }
}
