//
//  RetrunManagement.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI
import Kingfisher

struct ReturnManagement: View {
    
    let userInfo: User
    let returnInfo: ReturnInfo
    @State private var review: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    KFImage(URL(string: returnInfo.imageSource)!).onFailure { err in
                        print(err.errorDescription ?? "KFImage err")
                    }
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(5)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(returnInfo.itemName)
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                            Text("기한 내 반납")
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                                .foregroundColor(Color.Navy_1E2F97)
                        }
                        
                        Text("2022.08.02 ~ 2022.08.08")
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    }
                    
                    Spacer()
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("완료")
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                            .foregroundColor(Color.LabelColor)
                    }
                }
                
                HStack {
                    Spacer()
                    
                    KFImage(URL(string: returnInfo.imageSource)!).onFailure { err in
                        print(err.errorDescription ?? "KFImage err")
                    }
                    .resizable()
                    .frame(width: 300, height: 300)
                    .cornerRadius(20)
                    Spacer()
                }
                
                Text("대여인 정보")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                Text(userInfo.name)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    .padding(.top, -15)
                
                Text("대여 후기")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                
                TextEditor(text: $review)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .submitLabel(.done)
                    .frame(height: 100)
                    .overlay{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.Gray_DEE2E6, lineWidth: 2)
                    }
                
                Text("별점")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                
                HStack {
                    ForEach(0..<5, id: \.self) { _ in
                        Circle()
                            .fill(Color.Gray_DEE2E6)
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }
}

struct RetrunManagement_Previews: PreviewProvider {
    static var previews: some View {
        ReturnManagement(userInfo: User.dummyUser(), returnInfo: ReturnInfo.dummyReturnInfo())
    }
}
