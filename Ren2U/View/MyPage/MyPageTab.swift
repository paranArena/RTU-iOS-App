//
//  MyPage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Kingfisher
import Introspect

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
            .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Content.allCases, id: \.rawValue) { content in
                    ContentView(content: content)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                    Divider()
                }
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
    
    @ViewBuilder
    private func ContentView(content: Content) -> some View {
        switch content {
        case .checkProfile:
            ProfileNavigation()
        case .alarm:
            AlaramNavigation()
        case .notice:
            NoticeNavigation()
        case .term:
            TermNavigation()
        case .logout:
            LogoutButton()
        }
    }
    
    @ViewBuilder
    private func ProfileNavigation() -> some View {
        NavigationLink("프로필 확인") {
            Profile()
        }
    }
    
    @ViewBuilder
    private func AlaramNavigation() -> some View {
        NavigationLink("알림") {
            Text("Emptry View")
        }
    }
    
    @ViewBuilder
    private func NoticeNavigation() -> some View {
        NavigationLink("공지사항") {
            Text("Emptry View")
        }
    }
    
    @ViewBuilder
    private func TermNavigation() -> some View {
        NavigationLink("이용약관") {
            Text("Emptry View")
        }
    }
    
    @ViewBuilder
    private func LogoutButton() -> some View {
        Button("로그아웃") {
            authVM.logout()
        }
    }
}

struct MyPage_Previews: PreviewProvider {
    static var previews: some View {
        MyPageTab()
    }
}
