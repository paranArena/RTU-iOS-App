//
//  Search.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/28.
//

import SwiftUI

struct GroupSearch: View {
    
    @Binding var search: String
    @Binding var tabSelection: Int
    @State private var groupInfo = [ClubData]()
    @EnvironmentObject var groupVM: GroupViewModel
    @State private var isActive = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("검색된 그룹 목록")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            
            ScrollView {
                VStack {
//                    ForEach(groupInfo, id: \.self) { searchCLubData in
//                        Button {
//                            isActive = true
//                        } label: {
//                            JoinedGroupCell(info: )
//                                .overlay(ApplicatedGroupOverlay())
//                        }
//                    }
                }
            }
        }
//        .background {
//            NavigationLink(isActive: $isActive) {
//                GroupPage(tabSelection: $tabSelection, groupInfo: )
//            } label: { }
//        }
        .onAppear {
            Task {
                groupInfo = await groupVM.searchClubsAll()
            }
        }
    }
    
    func JoinedGroupOverlay() -> some View {
        HStack {
            Spacer()
            Text("가입된 그룹")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.gray_DEE2E6)
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
                .background(Capsule().fill(Color.navy_1E2F97))
        }
        .padding()
    }
    
    func NoneOverlay() -> some View {
        HStack {
            Spacer()
            Text("가입 요청")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.navy_1E2F97)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .overlay(
                    Capsule()
                        .strokeBorder(Color.navy_1E2F97, lineWidth: 2)
                )
        }
        .padding()
    }
}


//struct Search_Previews: PreviewProvider {
//    static var previews: some View {
//        Search()
//    }
//}
