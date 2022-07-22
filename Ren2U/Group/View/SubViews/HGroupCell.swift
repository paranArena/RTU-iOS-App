//
//  HGroupCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Kingfisher

struct HGroupCell: View {
    
    let info: GroupInfo
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            KFImage(URL(string: info.imageSource)!)
                .onFailure { err in
                    print(err.errorDescription)
                }
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(20)
            
            VStack(alignment: .leading) {
                Text(info.groupName)
                    .font(.system(size: 16, weight: .medium))
                
                HStack {
                    ForEach(info.tags, id: \.self) { tag in
                        Text("#\(tag.tag)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.Gray_DEE2E6)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct HGroupCell_Previews: PreviewProvider {
    static var previews: some View {
        HGroupCell(info: GroupInfo.dummyGroup())
    }
}
