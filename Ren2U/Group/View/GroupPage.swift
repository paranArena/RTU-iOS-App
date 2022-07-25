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
    let groupRole: GroupRole = .chairman
    let notices = NoticeInfo.dummyNotices()
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.BackgroundColor)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    KFImage(URL(string: groupInfo.imageSource)!).onFailure { err in
                            print(err.errorDescription)
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
                Text(groupInfo.groupName)
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
                    }

                case .member:
                    Button {
                        
                    } label: {
                        Text("탈퇴하기")
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    }

                case .application:
                    Button {
                        
                    } label: {
                        Text("가입취소")
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    }
                case .none:
                    Text("가입하기")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                }
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
            .padding(.leading)
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
            
            ForEach(0..<3, id: \.self) { index in
                NoticeCell(noticeInfo: notices[index])
            }
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
                    
                }
            }
        }
    }
}

struct GroupPage_Previews: PreviewProvider {
    static var previews: some View {
        GroupPage(groupInfo: GroupInfo.dummyGroup())
    }
}
