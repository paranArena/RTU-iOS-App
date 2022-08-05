//
//  MyPage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct MyPage: View {
    
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

        }
    }
}

struct MyPage_Previews: PreviewProvider {
    static var previews: some View {
        MyPage()
    }
}
