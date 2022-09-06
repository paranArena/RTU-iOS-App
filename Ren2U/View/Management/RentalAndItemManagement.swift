//
//  RentalAndtemManagement.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI
import HidableTabView

extension RentalAndItemManagement {
    
    enum Selection: Int, CaseIterable {
        case rentalManagement
        case itemManagement
        
        var title: String {
            switch self {
            case .rentalManagement:
                return "대여 관리"
            case .itemManagement:
                return "물품 관리"
            }
        }
    }
}


struct RentalAndItemManagement: View {
    
    @State private var headerSelection: Selection = .rentalManagement
    @ObservedObject var managementVM: ManagementViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            ButtonHeaderSelection()
            
            if headerSelection == .rentalManagement {
                RentalManagementSelected()
            } else {
                ProductManageView(managementVM: managementVM)
            }
        }
        .onAppear {
            UITabBar.hideTabBar()
        }
        .frame(maxWidth: .infinity, maxHeight:  .infinity)
        .basicNavigationTitle(title: "대여/물품 관리")
        .avoidSafeArea()
    }
    
    @ViewBuilder
    private func ButtonHeaderSelection() -> some View {
        HStack {
            ForEach(Selection.allCases, id: \.rawValue) {  option in
                Button {
                    self.headerSelection = option
                } label: {
                    Text(option.title)
                        .frame(maxWidth: .infinity)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 18))
                        .foregroundColor(self.headerSelection == option ? .navy_1E2F97 : .gray_ADB5BD)
                }

            }
        }
    }
}
//
//struct RentalAndtemManagement_Previews: PreviewProvider {
//    static var previews: some View {
//        RentalAndItemManagement()
//    }
//}
