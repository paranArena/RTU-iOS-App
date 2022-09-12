//
//  GroupPage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import SwiftUI
import Kingfisher

struct ClubPage: View {
    
    @EnvironmentObject var tabVM: AmongTabsViewModel
    @EnvironmentObject var clubVM: ClubViewModel
    @Binding var tabSelection: Int
    @Binding var clubData: ClubAndRoleData
    
    @State private var offset: CGFloat = 0
    @State private var isActive = false
    
    //  Alter를 위한 변수
    @State private var isShoiwngAlert = false
    
    var body: some View {
        
        BounceControllScrollView(baseOffset: 80, offset: $offset) {
            VStack(alignment: .leading) {
                Thumbnail()
                Tags()
                Introduction()
                
                Group {
                    Notice()
                    RentalItem()
                }
                .isHidden(hidden: clubData.clubRole == ClubRole.wait.rawValue || clubData.clubRole == ClubRole.none.rawValue)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            clubVM.searchNotificationsAll(clubId: clubData.id)
        }
        .overlay(ShadowRectangle())
        .background(
            NavigationLink(isActive: $isActive, destination: {
                ClubManagementView(managementVM: ManagementViewModel(clubData: clubData.extractClubData()))
            }, label: {}) 
        )
        .basicNavigationTitle(title: "")
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text(clubData.name)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                TrailingToolbar()
            }
        }
        .alert("", isPresented: $isShoiwngAlert) {
            Button("취소", role: .cancel) {}
            
            Button {
                if clubData.clubRole == ClubRole.user.rawValue {
                    Task {
                        await clubVM.leaveClub(clubId: clubData.id)
                        clubData.clubRole = await clubVM.getMyClubRole(clubId: clubData.id)
                    }
                } else if clubData.clubRole == ClubRole.wait.rawValue {
                    Task {
                        await clubVM.cancelClubJoin(clubId: clubData.id)
                        clubData.clubRole = await clubVM.getMyClubRole(clubId: clubData.id)
                    }
                } else if clubData.clubRole == ClubRole.none.rawValue {
                    Task {
                        await clubVM.requestClubJoin(clubId: clubData.id)
                        clubData.clubRole = await clubVM.getMyClubRole(clubId: clubData.id)
                    }
                }
            } label: {
                Text("확인")
            }
        } message: {
            if clubData.clubRole == ClubRole.user.rawValue {
                Text("그룹을 탈퇴하시겠습니까?")
            } else if clubData.clubRole == ClubRole.wait.rawValue {
                Text("가입을 취소하시겠습니까?")
            } else if clubData.clubRole == ClubRole.none.rawValue {
                Text("그룹에 가입하시겠습니까? ")
            }
        }

            
    }
    
    @ViewBuilder
    private func Thumbnail() -> some View {
        HStack {
            Spacer()
            RepresentativeImage(url: clubData.thumbnailPath)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func Tags() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(clubData.hashtags, id: \.self) { tag in
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
            
            Text(clubData.introduction)
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
                
                NavigationLink {
                    ClubNotifications()
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray_495057)
                }
            }
            .padding(.horizontal)
            
            ForEach(clubVM.clubNotice.indices, id: \.self) { i in
                if i < 5 {
                    NoticeCell(noticeInfo: clubVM.clubNotice[i], groupName: clubVM.getGroupNameByGroupId(groupId: clubData.id))
                }
            }
            
            Text("공지사항이 없습니다.")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 20))
                .foregroundColor(.gray_DEE2E6)
                .isHidden(hidden: !clubVM.clubNotice.isEmpty)
                .padding(.horizontal)
            
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
                    tabVM.selectedClubId = clubData.id
                    self.tabSelection = Ren2UTab.Selection.rent.rawValue
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray_495057)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(clubVM.products.indices, id: \.self) { i in
                        Button {
                            clubVM.products[i].isActive = true
                            self.tabSelection = Ren2UTab.Selection.rent.rawValue

                        } label: {
                            RentalItemVCell(rentalItem: clubVM.products[i].data)
                        }
                        .isHidden(hidden: clubVM.products[i].data.clubId != clubData.id)
                    }
                }
                .padding(.horizontal)
            }
            .blur(radius: clubData.clubRole == ClubRole.wait.rawValue || clubData.clubRole == ClubRole.none.rawValue ? 4 : 0 , opaque: false)
            .opacity(clubData.clubRole == ClubRole.wait.rawValue || clubData.clubRole == ClubRole.none.rawValue ? 0.7 : 1)
        }
    }
    
    @ViewBuilder
    private func TrailingToolbar() -> some View {
        if clubData.clubRole == "OWNER" || clubData.clubRole == "ADMIN" {
            Button {
                isActive = true
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(Color.LabelColor)
            }
        } else {
            Button {
                isShoiwngAlert = true
            } label: {
                Text(clubData.buttonText)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(Color.LabelColor)
            }
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
