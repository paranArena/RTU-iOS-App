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
    @Environment(\.isPresented) var isPresented
    @State private var isShowingModal = false
    
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
                self.isShowingModal.toggle()
            } label: {
                Text("탈퇴하기")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    .foregroundColor(.Gray_495057)
            }
            .frame(width: SCREEN_WIDTH - 40, height: 30, alignment: .leading)
            .padding(.leading, 15)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray_F1F2F3))

            
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
        .controllTabbar(isPresented)
        .disabled(isShowingModal)
        .navigationBarBackButtonHidden(isShowingModal)
        .overlay(Modal(isShowingModal: $isShowingModal, text: "탈퇴하시겠습니까?", callback: {
            print("Yes! on Ended ")
        }))
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
