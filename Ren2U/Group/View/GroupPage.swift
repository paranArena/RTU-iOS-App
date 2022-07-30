//
//  GroupPage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import SwiftUI
import Kingfisher

struct GroupPage: View {
    
    @EnvironmentObject var groupModel: GroupModel
    let groupInfo: GroupInfo
    let groupRole: GroupRole = .member
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.BackgroundColor)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    KFImage(URL(string: groupInfo.groupDto.imageSource)!).onFailure { err in
                        print(err.errorDescription ?? "KFImage err")
                        }
                        .resizable()
                        .frame(width: SCREEN_WIDTH, height: 215)
                    
                    Tags()
                    Introduction()
                    Notice()
                    RentalItem()
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text(groupInfo.groupDto.groupName)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                switch groupRole {
                case .chairman:
                    Menu {
                        Text("물품 등록")
                        Text("공지 등록")
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color.LabelColor)
                    }

                case .member:
                    Button {
                        
                    } label: {
                        Text("탈퇴하기")
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                            .foregroundColor(Color.LabelColor)
                    }

                case .application:
                    Button {
                        
                    } label: {
                        Text("가입취소")
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                            .foregroundColor(Color.LabelColor)
                    }
                case .none:
                    Text("가입하기")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                        .foregroundColor(Color.LabelColor)
                }
            }
        }
    }
    
    @ViewBuilder
    func Tags() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(groupInfo.groupDto.tags) { tag in
                    Text("#\(tag.tag)")
                        .foregroundColor(Color.Gray_495057)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                }
            }
            .foregroundColor(Color.Gray_495057)
            .padding(.leading)
            .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder
    func Introduction() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("소개글")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                .foregroundColor(Color.Gray_495057)
            
            Text(groupInfo.groupDto.intoduction)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
        }
        .padding(.horizontal)
        .padding(.bottom, 70)
    }
    
    @ViewBuilder
    func Notice() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("공지사항")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(Color.Gray_495057)
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.Gray_495057)
                }
            }
            .padding(.horizontal)
            
            ForEach(groupModel.notices) { notice in
                NoticeCell(noticeInfo: notice)
            }
            .blur(radius: groupRole == .none || groupRole == .application ? 4 : 0 , opaque: false)
            .opacity(groupRole == .none || groupRole == .application ? 0.7 : 1)
        }
        .padding(.bottom, 70)
    }
    
    @ViewBuilder
    func RentalItem() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("대여물품")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(Color.Gray_495057)
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.Gray_495057)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(groupModel.rentalItems) { rentalItem in
                        RentalItemCell(rentalItem: rentalItem)
                    }
                }
                .padding(.horizontal)
            }
            .blur(radius: groupRole == .none || groupRole == .application ? 4 : 0 , opaque: false)
            .opacity(groupRole == .none || groupRole == .application ? 0.7 : 1)
        }
    }
}

struct GroupPage_Previews: PreviewProvider {
    static var previews: some View {
        GroupPage(groupInfo: GroupInfo.dummyGroup())
    }
}
