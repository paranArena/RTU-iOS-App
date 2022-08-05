//
//  MyPage.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/22.
//

import SwiftUI

struct MyPage: View {
    
    @EnvironmentObject var authModel: AuthViewModel
    
    var body: some View {
        Button {
            authModel.jwt = nil
        } label: {
            Text("로그아웃")
        }
    }
}

struct MyPage_Previews: PreviewProvider {
    static var previews: some View {
        MyPage()
    }
}
