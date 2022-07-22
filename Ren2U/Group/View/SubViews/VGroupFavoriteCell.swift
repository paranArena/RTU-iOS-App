//
//  GroupFavoriteCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Kingfisher

struct VGroupFavoriteCell: View {
    
    let info: GroupInfo
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            KFImage(URL(string: info.imageSource)!)
                .onFailure { err in
                    print(err.errorDescription)
                }
                .resizable()
                .frame(width: 130, height: 130)
                .cornerRadius(20)
            
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
        .overlay {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        print("Star clicked!")
                    } label: {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    .padding(5)

                }
                Spacer()
            }
        }
    }
}

struct GroupFavoriteCell_Previews: PreviewProvider {
    static var previews: some View {
        VGroupFavoriteCell(info: GroupInfo.dummyGroup())
    }
}
