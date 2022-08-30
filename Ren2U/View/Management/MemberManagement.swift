//
//  MemberManament.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI
import HidableTabView

struct MemberManagement: View {
    
    @State private var selection: Selection = .member
    
    var body: some View {
        VStack {
            SelectionButton()
        }
        .basicNavigationTitle(title: "멤버 관리")
        .onAppear {
            UITabBar.hideTabBar(animated: false)
        }
    }
    
    @ViewBuilder
    private func SelectionButton() -> some View {
        HStack {
            ForEach(Selection.allCases, id: \.rawValue) {  option in
                Button {
                    self.selection  = option
                } label: {
                    Text(option.title)
                        .frame(maxWidth: .infinity)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 18))
                        .foregroundColor(self.selection == option ? .navy_1E2F97 : .gray_ADB5BD)
                }

            }
        }
    }
}

extension MemberManagement {
    
    enum Selection: Int, CaseIterable {
        case member
        case applicant
        
        var title: String {
            switch self {
            case .member:
                return "등록된 멤버"
            case .applicant:
                return "가입신청"
            }
        }
    }
}

struct MemberManament_Previews: PreviewProvider {
    static var previews: some View {
        MemberManagement()
    }
}
