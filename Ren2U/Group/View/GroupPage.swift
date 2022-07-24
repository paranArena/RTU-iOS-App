//
//  GroupPage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import SwiftUI
import Kingfisher

struct GroupPage: View {
    
    let groupInfo: GroupInfo
    
    var body: some View {
        VStack {
            KFImage(URL(string: groupInfo.imageSource)!).onFailure { err in
                    print(err.errorDescription)
                }
                .resizable()
                .frame(width: SCREEN_WIDTH, height: 215)
            Tags()
            Introduction()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text(groupInfo.groupName)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            }
        }
    }
    
    @ViewBuilder
    func Tags() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(groupInfo.tags) { tag in
                    Text("#\(tag.tag)")
                        .foregroundColor(Color.Gray_495057)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                }
            }
            .foregroundColor(Color.Gray_495057)
        }
    }
    
    @ViewBuilder
    func Introduction() -> some View {
        VStack(alignment: .leading) {
            Text("소개글")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                .foregroundColor(Color.Gray_495057)
            
            Text(groupInfo.intoduction)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
        }
    }
}

struct GroupPage_Previews: PreviewProvider {
    static var previews: some View {
        GroupPage(groupInfo: GroupInfo.dummyGroup())
    }
}
