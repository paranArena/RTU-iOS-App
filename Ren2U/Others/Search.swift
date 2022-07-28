//
//  Search.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/28.
//

import SwiftUI

struct Search: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("검색된 그룹 목록")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            
            ScrollView {
                VStack {
                    ForEach(0..<10) { index in
                        NavigationLink {
                            GroupPage(groupInfo: GroupInfo.dummyGroups())
                        } label: {
                            JoinedGroupCell(info: GroupInfo.dummyGroups())
                                .overlay(ApplicatedGroupOverlay())
                        }
                    }
                }
            }
        }
    }
    
    func JoinedGroupOverlay() -> some View {
        HStack {
            Spacer()
            Text("가입된 그룹")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.Gray_DEE2E6)
        }
        .padding()
    }
    
    func ApplicatedGroupOverlay() -> some View {
        HStack {
            Spacer()
            Text("요청완료")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.Navy_1E2F97))
        }
        .padding()
    }
    
    func NoneOverlay() -> some View {
        HStack {
            Spacer()
            Text("가입 요청")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.Navy_1E2F97)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .overlay(
                    Capsule()
                        .strokeBorder(Color.Navy_1E2F97, lineWidth: 2)
                )
        }
        .padding()
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
