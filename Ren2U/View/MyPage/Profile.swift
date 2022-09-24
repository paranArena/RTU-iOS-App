//
//  Profile.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/29.
//

import SwiftUI
import Kingfisher
import MapKit

extension Profile {
    enum Field: Int, CaseIterable {
        case name
        case major
        case studentId
        case email
        case phoneNumber
        
        var title: String {
            switch self {
            case .name:
                return "이름"
            case .major:
                return "학과"
            case .studentId:
                return "학번"
            case .email:
                return "이메일"
            case .phoneNumber:
                return "전화번호"
            }
        }
    }
}

struct Profile: View {
    
    @EnvironmentObject var myPageVM: MyPageViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.isPresented) var isPresented
    
    @State private var alert = Alert()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack(alignment: .center) {
                KFImage(URL(string: "https://picsum.photos/seed/picsum/200/300")!)
                    .onFailure { err in
                        print(err.errorDescription ?? "KFImage err")
                    }
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            }
            .frame(maxWidth: .infinity)
            
            ForEach(Field.allCases, id: \.rawValue) { field in
                ProfileField(field: field)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                ChangePasswordButton()
                Divider()
                    .padding(.horizontal, 10)
                ServiceQuitButton()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray_F1F2F3))
        }
        .padding(.horizontal, 15)
        .basicNavigationTitle(title: "프로필 확인")
        .controllTabbar(isPresented)
        .alert("", isPresented: $alert.isPresented) {
            Button("취소", role: .cancel) {}
            Button("예") { Task { await alert.callback() }}
        } message: {
            alert.message
        }
    }
    
    
    @ViewBuilder
    private func ProfileField(field: Field) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(field.title)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
            
            
            Group {
                switch field {
                case .email:
                    Text(myPageVM.userData!.email)
                case .name:
                    Text(myPageVM.userData!.name)
                case .major:
                    Text(myPageVM.userData!.major)
                case .studentId:
                    Text(myPageVM.userData!.studentId)
                case .phoneNumber:
                    Text(myPageVM.userData!.phoneNumber)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.gray_DEE2E6)
                    .frame(height: 1)
            }
            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func ChangePasswordButton() -> some View {
        NavigationLink {
            PasswordResetView(pwVM: PasswordViewModel(email: myPageVM.userData?.email ?? ""))
        } label: {
            Text("비밀번호 변경")
                .padding(.leading, 15)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
                .frame(maxWidth: .infinity, alignment: .leading)
        }

    }
    
    @ViewBuilder
    private func ServiceQuitButton() -> some View {
        Button {
            alert.isPresented = true
            alert.message = Text("탈퇴하시겠습니까?")
            alert.callback = myPageVM.quitService
        } label: {
            Text("탈퇴하기")
                .padding(.leading, 15)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile()
//    }
//}
