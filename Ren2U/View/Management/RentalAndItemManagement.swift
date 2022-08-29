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
    @Environment(\.isPresented) var isPresented
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            ButtonHeaderSelection()
            
            ZStack {
                ForEach(Selection.allCases, id: \.rawValue) { selection in
                    Content()
                        .offset(x: CGFloat((selection.rawValue - self.headerSelection.rawValue)) * SCREEN_WIDTH)
                }
            }
            .animation(.default, value: headerSelection)
        }
        .onAppear {
            UITabBar.hideTabBar()
            print("Hide Tab Bar")
        }
        .frame(maxWidth: .infinity, maxHeight:  .infinity)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("대여/물품 관리")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            }
        }
    }
    
    @ViewBuilder
    private func Content() -> some View {
        switch headerSelection {
        case .rentalManagement:
            RentalManagementSelected() 
        case .itemManagement:
            ItemManagementSelected()
        }
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

struct RentalAndtemManagement_Previews: PreviewProvider {
    static var previews: some View {
        RentalAndItemManagement()
    }
}
