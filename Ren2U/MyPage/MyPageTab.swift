//
//  MyPage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct MyPageTab: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        VStack {
            Button {
                authViewModel.logout()
            } label: {
                Text("로그아웃")
            }
            
            Button {
                Task { await authViewModel.getMyInfo() }
            } label: {
                Text("개인정보조회")
            }
            
            NavigationLink {
                GroupManagement()
            } label: {
                Text("그룹 관리 임시 버튼 ")
            }

        }
        .navigationTitle(" ")
    }
}

struct MyPage_Previews: PreviewProvider {
    static var previews: some View {
        MyPageTab()
    }
}
