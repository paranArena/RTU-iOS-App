//
//  Profile.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import SwiftUI
import Kingfisher

struct Profile: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            KFImage(URL(string: authVM.user?.imageSource ?? "https://picsum.photos/seed/picsum/200/300")!)
                .onFailure { err in
                    print(err.errorDescription ?? "KFImage err")
                }
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            
            Button {
                
            } label: {
                Text("사진 변경")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    .foregroundColor(.navy_1E2F97)
            }
            
            Button {
                
            } label: {
                Text("탈퇴하기")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    .foregroundColor(.Gray_495057)
            }
            .padding()
            .frame(maxWidth: .infinity)

            
        }
        .basicNavigationTitle(title: "프로필 확인")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("완료")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                }
            }
        }
    }
    
    @ViewBuilder
    private func Fields() -> some View {
        ForEach(SignUp.Field.allCases, id: \.rawValue) { field in
            VStack {
                Text(field.title)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
