//
//  GroupPage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import SwiftUI
import Kingfisher

struct ClubPage: View {
    
    @EnvironmentObject var clubVM: ClubViewModel
    @Binding var tabSelection: Int
    @Binding var groupInfo: ClubAndRoleData
    @State var offset: CGFloat = 0
    @State var isActive = false
    
    
    var body: some View {
        
        BounceControllScrollView(baseOffset: 80, offset: $offset) {
            VStack(alignment: .leading) {
                Thumbnail()
                Tags()
                Introduction()
                Notice()
                RentalItem()
                Spacer()
            }
        }
        .overlay(ShadowRectangle())
        .background(
            NavigationLink(isActive: $isActive, destination: {
                ClubManagementView(managementVM: ManagementViewModel(clubData: groupInfo.extractClubData()))
            }, label: {}) 
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text(groupInfo.name)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                TrailingToolbar()
            }
        }
            
    }
    
    @ViewBuilder
    private func Thumbnail() -> some View {
        Group{
            if let thumbnaulPath = groupInfo.thumbnailPath {
                KFImage(URL(string: thumbnaulPath))
                    .onFailure { err in
                        print(err.errorDescription ?? "KFImage Optional err")
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
            } else {
                Image(AssetImages.DefaultGroupImage.rawValue)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    private func Tags() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(groupInfo.hashtags, id: \.self) { tag in
                    Text("#\(tag)")
                }
            }
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
            .foregroundColor(Color.gray_495057)
            .padding(.leading)
            .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder
    private func Introduction() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("소개글")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                .foregroundColor(Color.gray_495057)
            
            Text(groupInfo.introduction)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
        }
        .padding(.horizontal)
        .padding(.bottom, 70)
    }
    
    @ViewBuilder
    private func Notice() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("공지사항")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(Color.gray_495057)
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray_495057)
                }
            }
            .padding(.horizontal)
            
            ForEach(clubVM.notices[groupInfo.id]?.reversed().indices ?? 0..<0, id: \.self) { i in
                NoticeCell(noticeInfo: clubVM.notices[groupInfo.id]![i], groupName: clubVM.getGroupNameByGroupId(groupId: groupInfo.id))
            }
            
//            ForEach(groupModel.notices) { notice in
//                NoticeCell(noticeInfo: notice)
//            }
//            .blur(radius: groupRole == .none || groupRole == .application ? 4 : 0 , opaque: false)
//            .opacity(groupRole == .none || groupRole == .application ? 0.7 : 1)
        }
        .padding(.bottom, 70)
    }
    
    @ViewBuilder
    private func RentalItem() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("대여물품")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(Color.gray_495057)
                Spacer()
                
                
                Button {
                    self.tabSelection = Ren2UTab.Selection.rent.rawValue
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray_495057)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(clubVM.rentalItems) { rentalItem in
                        Button {
                            self.tabSelection = Ren2UTab.Selection.rent.rawValue
                        } label: {
                            RentalItemVCell(rentalItem: rentalItem)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .blur(radius: groupInfo.clubRole == GroupRole.wait.rawValue || groupInfo.clubRole == GroupRole.none.rawValue ? 4 : 0 , opaque: false)
            .opacity(groupInfo.clubRole == GroupRole.wait.rawValue || groupInfo.clubRole == GroupRole.none.rawValue ? 0.7 : 1)
        }
    }
    
    @ViewBuilder
    private func TrailingToolbar() -> some View {
        switch groupInfo.clubRole {
        case GroupRole.owner.rawValue:
            Button {
                isActive = true
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(Color.LabelColor)
            }
        case GroupRole.user.rawValue:
            Button {

            } label: {
                Text("탈퇴하기")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(Color.LabelColor)
            }

        case GroupRole.wait.rawValue:
            Button {

            } label: {
                Text("가입취소")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(Color.LabelColor)
            }
        case GroupRole.none.rawValue:
            Text("가입하기")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                .foregroundColor(Color.LabelColor)
        default:
            Text("트레일링 바")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
        }
    }
    
    @ViewBuilder
    private func LikeStar() -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
//                    groupInfo.didLike.toggle()
//                    if groupInfo.didLike {
//                        groupModel.likesGroup(group: groupInfo)
//                    } else {
//                        groupModel.unlikeGroup(group: groupInfo)
//                    }
                } label: {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                }
                .padding(5)

            }
            Spacer()
        }
    }
}

//struct GroupPage_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupPage(groupInfo: GroupInfo.dummyGroup())
//    }
//}
