//
//  MyPage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Kingfisher

struct MyPageTab: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        
        VStack {
            
            HStack {
                KFImage(URL(string: authVM.user?.imageSource ?? "https://picsum.photos/seed/picsum/200/300")!)
                    .onFailure { err in
                        print(err.errorDescription ?? "KFImage err")
                    }
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .padding(.trailing, 30)
                
                VStack(alignment: .trailing, spacing: 0) {
                    Text("\(authVM.user!.major) \(authVM.user!.studentId.substring(from: 2, to: 3))학번")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        .foregroundColor(.gray_868E96)
                    
                    Text("\(authVM.user!.name)")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                    
                    HStack {
                        VStack {
                            Text("50")
                                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 30))
                            
                            Text("총 대여횟수")
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 10))
                                .foregroundColor(.gray_868E96)
                        }
                        
                        
                        Spacer()
                        
                        VStack {
                            Text("50")
                                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 30))
                            
                            Text("기간 내 반납")
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 10))
                                .foregroundColor(.gray_868E96)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                
                NavigationLink("프로필 확인") {
                    Profile() 
                }
                
                Divider()
                
                Button("로그아웃") {
                    authVM.logout()
                }
                
                Divider()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10 )
            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
            .background(Color.gray_DEE2E6)
            .cornerRadius(15)
            
            
            Spacer() 
        }
        .basicNavigationTitle(title: "")
        .padding(.horizontal, 10)
    }
}

struct MyPage_Previews: PreviewProvider {
    static var previews: some View {
        MyPageTab()
    }
}
