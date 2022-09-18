//
//  Rent.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import HidableTabView

extension RentalTab {
    enum Selection: Int, CaseIterable {
        case rentalItem
        case rentalList
        
        var title: String {
            switch self {
            case .rentalItem:
                return "대여물품"
            case .rentalList:
                return "대여목록"
            }
        }
    }
}

extension RentalTab {
    enum CancelSelection: Int, CaseIterable {
        case `default`
        case none
        case yes
        case no
    }
}


struct RentalTab: View {
    
    @EnvironmentObject var clubVM: ClubViewModel
    @EnvironmentObject var tabVM: AmongTabsViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var rentalSelection: Selection = .rentalItem
    @State private var searchText = ""
    @State private var isSearchBarFocused = false
    @State private var offset: CGFloat = 200
    @State private var cancelSelection: CancelSelection = .none
    @State private var isShowingModal = false
    
    
    @State private var selectedRentData: RentalData?
    @State private var isActiveMap = false
    // 예약 취소를 위한 값들
    @State private var selectedClubId = -1
    @State private var selectedItemId = -1
    @State private var alert = Alert()
    @State private var singleButtonAlert = Alert()
    
    let spacing: CGFloat = 10
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            SearchBar(text: $searchText, isFoucsed: $isSearchBarFocused)
                .padding(.horizontal, 20)
            
            FilterView()

            
            Group {
                RentalSelectionButton()
                    
                ZStack {
                    ForEach(Selection.allCases, id: \.rawValue) { selection in
                        Content(selection: selection)
                            .offset(x: CGFloat((selection.rawValue - self.rentalSelection.rawValue)) * SCREEN_WIDTH)
                    }
                }
                
            }
        }
        .alert("", isPresented: $alert.isPresented) {
            Button("아니오", role: .cancel) {}
            Button("예") {
                Task { await alert.callback() } 
            }
        } message: {
            Text(alert.title)
        }
        .alert(singleButtonAlert.title, isPresented: $singleButtonAlert.isPresented) {
            Button("확인", role: .cancel) {}
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
        .background(
            NavigationLink(isActive: $isActiveMap) {
                if let selectedRentData = selectedRentData {
                    ItemMap(itemInfo: selectedRentData)
                }
            } label: { }

        )
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
        .isHidden(hidden: isSearchBarFocused)
        .background(GeometryReader { gp -> Color in
            offset = gp.frame(in: .global).maxY + spacing
            return Color.clear
        })
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
            Group {
                VStack {
                    ForEach(clubVM.products.indices, id: \.self) { i in
                        NavigationLink(isActive: $clubVM.products[i].isActive) {
                            ProductDetailView(clubId: clubVM.products[i].data.clubId, productId: clubVM.products[i].data.id)
                        } label: {
                            ProductCell(rentalItemInfo: clubVM.products[i].data)
                        }
                        .isHidden(hidden: tabVM.selectedClubId != nil && clubVM.products[i].data.clubId != tabVM.selectedClubId)
                        .isHidden(hidden: isSearchBarFocused && !clubVM.products[i].data.name.contains(searchText) && !clubVM.products[i].data.clubName.contains(searchText))
                    }
                }
                .isHidden(hidden: clubVM.products.isEmpty)
                
                Text("대여할 수 있는 물품이 없습니다.")
                    .font(.custom(CustomFont.NSKRBold.rawValue, size: 20))
                    .foregroundColor(.gray_DEE2E6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .isHidden(hidden: !clubVM.products.isEmpty)
                    
            }
        }
        .refreshable {
            clubVM.getMyClubs()
            clubVM.getMyNotifications()
            await clubVM.getMyProducts()
            await clubVM.getMyRentals()
        }
    }
    
    @ViewBuilder
    private func RentalListSelected() -> some View {
        RefreshableScrollView(threshold: 120) {
            Group {
                VStack {
                    ForEach(clubVM.rentals.indices, id:\.self) { i in
                        Button {
                            if locationManager.requestAuthorization() {
                                selectedRentData = clubVM.rentals[i]
                                isActiveMap = true
                            }
                        } label: {
                            RentalCell(rentalItemInfo: clubVM.rentals[i], alert: $alert, singleButtonAlert: $singleButtonAlert)
                                .isHidden(hidden: tabVM.selectedClubId != nil && clubVM.rentals[i].clubId != tabVM.selectedClubId)
                                .isHidden(hidden: isSearchBarFocused && !clubVM.rentals[i].clubName.contains(searchText) && !clubVM.rentals[i].name.contains(searchText))
                        }
                    }
                }
                .isHidden(hidden: clubVM.rentals.isEmpty)
                
                Text("대여 중인 물품이 없습니다.")
                    .font(.custom(CustomFont.NSKRBold.rawValue, size: 20))
                    .foregroundColor(.gray_DEE2E6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .isHidden(hidden: !clubVM.rentals.isEmpty)
            }
        }
        .refreshable {
            clubVM.getMyClubs()
            clubVM.getMyNotifications()
            await clubVM.getMyProducts()
            await clubVM.getMyRentals()
        }
    }
    
    @ViewBuilder
    private func FilterView() -> some View {
        HStack {
            if let clubId = tabVM.selectedClubId {
                Text("필터링 결과")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.gray_495057)
                
                HStack(spacing: 10) {
                    Text(clubVM.getGroupNameByGroupId(groupId: clubId))
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 13))
                        .foregroundColor(.gray_495057)
                    
                    Button {
                        tabVM.selectedClubId = nil
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 8, height: 8)
                            .foregroundColor(.gray_495057)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().stroke(Color.gray_495057, lineWidth: 1))
            }
        }
        .isHidden(hidden: tabVM.selectedClubId == nil)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Rent_Previews: PreviewProvider {
    static var previews: some View {
        RentalTab()
    }
}
