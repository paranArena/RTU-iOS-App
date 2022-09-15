//
//  MyPage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI
import Kingfisher
import Introspect


extension MyPageTab {
    enum Content: Int, CaseIterable {
        case checkProfile
//        case alarm
//        case notice
        case term
        case privacy
        case logout
    }
}


struct MyPageTab: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var loginManager: LoginManager
    @State private var isShowingAlert = false
    @State private var alertTitle = ""
    @State private var callback: () -> () = { print("callback")}
    
    var body: some View {
        
        VStack {
            HStack {
                KFImage(URL(string: "https://picsum.photos/seed/picsum/200/300")!)
                    .onFailure { err in
                        print(err.errorDescription ?? "KFImage err")
                    }
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .padding(.trailing, 30)
                
                VStack(alignment: .trailing, spacing: 0) {
                    Text("\(authVM.userData?.major ?? "") \(authVM.userData?.studentId.substring(from: 2, to: 3) ?? "") 학번")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        .foregroundColor(.gray_868E96)
//
                    Text("\(authVM.userData?.name ?? "")")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
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
            
            Text("개발자 연락처\n nou0ggid@gmail.com")
                .multilineTextAlignment(.trailing)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_868E96)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                
        }
        .basicNavigationTitle(title: "")
        .padding(.horizontal, 10)
        .overlay(ShadowRectangle())
    }
    
    @ViewBuilder
    private func ContentView(content: Content) -> some View {
        switch content {
        case .checkProfile:
            ProfileNavigation()
//        case .alarm:
//            AlaramNavigation()
//        case .notice:
//            NoticeNavigation()
        case .term:
            TermNavigation()
        case .privacy:
            PrivacyNavigation()
        case .logout:
            LogoutButton()
        }
    }
    
    @ViewBuilder
    private func PrivacyNavigation() -> some View {
        NavigationLink("개인정보처리 방침") {
            PrivacyPolicy() 
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
            ToS()
        }
    }
    
    @ViewBuilder
    private func LogoutButton() -> some View {
        Button("로그아웃") {
            loginManager.isLogined = false
        }
    }
}

struct MyPage_Previews: PreviewProvider {
    static var previews: some View {
        MyPageTab()
    }
}
