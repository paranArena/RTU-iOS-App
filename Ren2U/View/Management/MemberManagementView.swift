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
    
    
    @State private var isShowingAlert = false
    
    @State private var isShowingSignUpAlert = false 
    @State private var selection: AlertSelection = .signUpCancel
    
    var body: some View {
        VStack {
            SelectionButton()
            
            Group {
                ForEach(Selection.allCases, id: \.rawValue) { selection in
                    Content(selection: selection)
                        .isHidden(hidden: selection != buttonSelection)
                }
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
        }
        .alert("", isPresented: $isShowingAlert) {
            Button("Cancel", role: .cancel) { }
            Button("OK") {
                Task {
                    await managementVM.removeMember(memberId: selectedCellID)
                    await managementVM.searchClubMembersAll()
                }
            }
        } message: {
            Text("멤버를 추방하시겠습니까?")
        }
        .alert("", isPresented: $isShowingSignUpAlert) {
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
        } message: {
            Text(selection == .signUpOk ? "가입신청을 승인하시겠습니까?" : "가입신청을 거부하시겠습니까?") 
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
        SlideResettableScrollView(selectedCellId: $selectedCellID) {
            VStack {
                ForEach(managementVM.members.indices, id: \.self) { index in
                    ManageMemberCell(memberInfo: managementVM.members[index], selectedCellID: $selectedCellID, isShowingAlert: $isShowingAlert, managementVM: managementVM)
                }
            }
        }
    }
    
    @ViewBuilder
    private func Applicant() -> some View {
        SlideResettableScrollView(selectedCellId: $selectedCellID) {
            VStack {
                ForEach(managementVM.applicants.indices, id: \.self) { index in
                    ManageSignUpCell(userData: managementVM.applicants[index], selectedCellID: $selectedCellID, isShowingSignUp: $isShowingSignUpAlert, alertSelection: $selection, managementVM: managementVM)
                }
            }
        }
    }
}

//struct MemberManament_Previews: PreviewProvider {
//    static var previews: some View {
//        MemberManagementView(managementVM:  ManagementViewModel(clubData: ClubData.dummyClubData()))
//    }
//}
