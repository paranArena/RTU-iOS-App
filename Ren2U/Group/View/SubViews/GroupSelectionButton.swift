//
//  GroupFilterButton.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct GroupSelectionButton: View {
    
    @Binding var selectionOption: GroupSelection
    private let selectionWidth = UIScreen.main.bounds.width / CGFloat(GroupSelection.allCases.count)
    
    var body: some View {
        HStack {
            ForEach(GroupSelection.allCases, id: \.self) {  option in
                Button {
                    withAnimation {
                        self.selectionOption = option
                    }
                } label: {
                    Text(option.title)
                        .frame(width: selectionWidth)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(selectionOption == option ? .Navy_1E2F97 : .Gray_ADB5BD)
                }

            }
        }
    }
}

struct GroupFilterButton_Previews: PreviewProvider {
    static var previews: some View {
        GroupSelectionButton(selectionOption: .constant(.group))
    }
}
