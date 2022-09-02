//
//  MemberManament.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI
import HidableTabView
import Introspect

extension MemberManagement {
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
struct MemberManagement: View {
    
    @ObservedObject var managementVM: ManagementViewModel
    @State private var buttonSelection: Selection = .member
    @State private var selectedCellID = 0
    
    var body: some View {
        VStack {
            SelectionButton()
            
            ZStack {
                ForEach(Selection.allCases, id: \.rawValue) { selection in
                    Content(selection: selection)
                        .offset(x: CGFloat((selection.rawValue - self.buttonSelection.rawValue)) * SCREEN_WIDTH)
                }
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            
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
            VStack { }
        case .applicant:
            Applicant()
        }
    }
    
    @ViewBuilder
    private func Applicant() -> some View {
        VStack {
            ForEach(managementVM.applicants.indices, id: \.self) { index in
                ManageSignUpCell(userData: managementVM.applicants[index], selectedCellID: $selectedCellID, managementVM: managementVM)
            }
        }
    }
}

struct MemberManament_Previews: PreviewProvider {
    static var previews: some View {
        MemberManagement(managementVM:  ManagementViewModel(groupId: 0))
    }
}
