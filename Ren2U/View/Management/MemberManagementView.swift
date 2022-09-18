//
//  MemberManament.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI
import HidableTabView
import Introspect

extension MemberManagementView {
    enum Selection: Int, CaseIterable {
        case member
        case applicant
        
        var title: String {
            switch self {
            case .member:
                return "등록된 멤버"
            case .applicant:
                return "가입 신청"
            }
        }
    }
}
struct MemberManagementView: View {
    
    enum AlertSelection {
        case signUpOk
        case signUpCancel
    }
    
    @ObservedObject var managementVM: ManagementViewModel
    @State private var buttonSelection: Selection = .member
    @State private var selectedCellID = 0
    
    @State private var maxY: CGFloat = .zero
    
    @State private var isShowingSignUpAlert = false 
    @State private var selection: AlertSelection = .signUpCancel
    
    var body: some View {
        VStack(spacing: 10) {
            
            MaxYSetterView(viewMaxY: $maxY) {
                SelectionButton()
            }
            
            Group {
                ForEach(Selection.allCases, id: \.rawValue) { selection in
                    Content(selection: selection)
                        .isHidden(hidden: selection != buttonSelection)
                }
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
        }
        .alert(selection == .signUpOk ? "가입신청을 승인하시겠습니까?" : "가입신청을 거부하시겠습니까?", isPresented: $isShowingSignUpAlert) {
            Button("Cancel", role: .cancel) { }
            Button("OK") {
                if selection == .signUpCancel {
                    Task {
                        await managementVM.rejectClubJoin(memberId: selectedCellID)
                        await managementVM.searchClubJoinsAll()
                    }
                } else {
                    Task {
                        await managementVM.acceptClubJoin(memberId: selectedCellID)
                        await managementVM.searchClubJoinsAll()
                        await managementVM.searchClubMembersAll()
                    }
                }
            }
        }
        .onAppear {
            UITabBar.hideTabBar()
        }
        .basicNavigationTitle(title: "멤버 관리")
    }
    
    @ViewBuilder
    private func SelectionButton() -> some View {
        HStack {
            ForEach(Selection.allCases, id: \.rawValue) {  option in
                Button {
                    self.buttonSelection  = option
                } label: {
                    Text(option.title)
                        .frame(maxWidth: .infinity)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 18))
                        .foregroundColor(self.buttonSelection == option ? .navy_1E2F97 : .gray_ADB5BD)
                }

            }
        }
    }
    
    @ViewBuilder
    private func Content(selection: Selection) -> some View {
        switch selection {
        case .member:
            Members()
        case .applicant:
            Applicant()
        }
    }
    
    @ViewBuilder
    private func Members() -> some View {
        RefreshableScrollView(threshold: maxY + 10) {
            Group {
                SwipeResettableView(selectedCellId: $selectedCellID) {
                    VStack {
                        ForEach(managementVM.members.indices, id: \.self) { index in
                            ManageMemberCell(memberInfo: managementVM.members[index], selectedCellID: $selectedCellID,  managementVM: managementVM)
                        }
                    }
                    .isHidden(hidden: managementVM.members.isEmpty)
                }
                
                Text("등록된 멤버가 없습니다.")
                    .font(.custom(CustomFont.NSKRBold.rawValue, size: 20))
                    .foregroundColor(.gray_DEE2E6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .isHidden(hidden: !managementVM.members.isEmpty)
            }
        }
    }
    
    @ViewBuilder
    private func Applicant() -> some View {
        RefreshableScrollView(threshold: maxY + 10) {
            Group {
                SwipeResettableView(selectedCellId: $selectedCellID) {
                    VStack {
                        ForEach(managementVM.applicants.indices, id: \.self) { index in
                            ManageSignUpCell(userData: managementVM.applicants[index], selectedCellID: $selectedCellID, isShowingSignUp: $isShowingSignUpAlert, alertSelection: $selection, managementVM: managementVM)
                        }
                    }
                }
                .isHidden(hidden: managementVM.applicants.isEmpty)
                
                Text("가입 신청 명단이 없습니다.")
                    .font(.custom(CustomFont.NSKRBold.rawValue, size: 20))
                    .foregroundColor(.gray_DEE2E6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .isHidden(hidden: !managementVM.applicants.isEmpty)
            }
        }
    }
}

//struct MemberManament_Previews: PreviewProvider {
//    static var previews: some View {
//        MemberManagementView(managementVM:  ManagementViewModel(clubData: ClubData.dummyClubData()))
//    }
//}
