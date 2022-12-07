//
//  GroupManagement.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI
import Introspect

struct ClubManagementView: View {
    
    @State private var rentalSelection: RentalSelection = .reservation
    @State private var rentalWidth: CGFloat = 0
    @State private var rentalToggle = false
    @Environment(\.isPresented) var isPresented
    
    @StateObject var managementVM: ManagementViewModel
    @StateObject var couponVM: CouponViewModel
    @EnvironmentObject var clubVM: ClubViewModel
    
    @Binding var clubActive: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {
                ManagingNavigation()
                
                Button {
                    Task {
                        managementVM.alertDeleteClub()
                    }
                } label: {
                    Text("그룹 삭제")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                        .foregroundColor(Color.primary)
                        .background(Color.gray_DEE2E6)
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal, 10)
        }
        .alert(couponVM.callbackButton.title, isPresented: $couponVM.callbackButton.isPresented) {
            Button("확인") {
                Task {
                    await couponVM.callbackButton.callback()
                }
            }
        } message: {
            couponVM.callbackButton.message
        }
        .alert("", isPresented: $managementVM.deleteClubAlert.isPresented) {
            Button("취소", role: .cancel) {}
            Button("확인") {
                Task {
                    await managementVM.deleteClubAlert.callback()
                    clubVM.getMyClubs()
                    clubActive = false
                }
            }
        } message: {
            managementVM.deleteClubAlert.message
        }
        .alert("", isPresented: $managementVM.alert.isPresented) {
            Button("취소", role: .cancel) {}
            Button("확인") { Task { await managementVM.alert.callback() }}
        } message: {
            Text("\(managementVM.alert.message)")
        }
        .controllTabbar(isPresented)
        .navigationTitle(" ")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("그룹 관리자")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            }
        }
    }
    
    
    //  나중에 추가
    @ViewBuilder
    private func Temp2() -> some View {
        VStack(alignment: .center, spacing: 0) {
            Text("대여현황")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.bottom, 20)
            
            HStack(spacing: 0) {
                ForEach(RentalSelection.allCases, id: \.rawValue) { selection in
                    Button {
                        self.rentalSelection = selection
                    } label: {
                        Text(selection.title)
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                            .foregroundColor(rentalSelection == selection ? Color.navy_1E2F97 : Color.gray_868E96)
                    }
                    .frame(maxWidth: .infinity)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewWidthKey.self, value: $0.frame(in: .global).width)
                    })
                    .onPreferenceChange(ViewWidthKey.self) {
                        rentalWidth = $0
                    }
                }
            }
            .padding(.bottom, 10)
            
            HStack {
                Rectangle()
                    .fill(Color.navy_1E2F97)
                    .frame(width: rentalWidth * 0.6, height: 2)
                    .padding(.leading, rentalWidth * CGFloat(rentalSelection.rawValue) + rentalWidth * 0.2)
                    .animation(.spring(), value: rentalSelection)
                Spacer()
            }
            
            
            VStack {
                Text("임시 텍스트 ")
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background(Color.BackgroundColor)
        }
        .background(Color.gray_DEE2E6)
        .cornerRadius(15)
    }
    
    @ViewBuilder
    private func ManagingNavigation() -> some View {
        VStack(alignment: .center, spacing: 0) {
            ForEach(ManageSelection.allCases, id : \.rawValue) { selection in
                HStack {
                    NavigationLink {
                        Navigation(selection: selection)
                    } label: {
                        Text(selection.title)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                            .foregroundColor(Color.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer()
                }
                Divider()
                    .padding(.horizontal, 10)
            }
        }
        .background(Color.gray_F1F2F3)
        .cornerRadius(15)
    }
    
    @ViewBuilder
    private func Navigation(selection: ManageSelection) -> some View {
        switch selection {
        case .profileEdit:
            ClubProfile(clubProfileService: ClubProfileViewModel(clubService: ClubProfileService(url: ServerURL.runningServer.url), clubId: managementVM.clubData.id))
//            ClubProfile(viewModel: ClubProfile.ViewModel(putModeData: managementVM.clubData, mode: .put))
        case .rentalManagement:
            RentalAndItemManagement(managementVM: managementVM)
        case .notice:
            NoticeManagementView(managementVM: managementVM)
        case .memberManagement:
            MemberManagementView(managementVM: managementVM)
        case .coupon:
            CouponManagementView(couponVM: couponVM, managementVM: managementVM)
        }
    }
}

//struct GroupManagement_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupManagement(managementVM: ManagementViewModel()
//    }
//}
