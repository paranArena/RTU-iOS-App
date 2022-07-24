//
//  CreateGroup.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import SwiftUI

struct CreateGroup: View {
    
    @StateObject var createGroupModel = CreateGroupModel()
    @FocusState var focusField: CreateGroupField?
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "camera")
                    .resizable()
                    .frame(width: SCREEN_WIDTH, height: 215)
                    .overlay(ChangeImageButton())
                    .foregroundColor(.Gray_495057)
                
                VStack(alignment: .leading, spacing: 70) {
                    GroupName()
                    Tag()
                    Introduction()
                    CreateCompleteButton()
                }
                .padding()
            }
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Text("그룹등록")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                }
        }
        }
    }
    
    @ViewBuilder
    func GroupName() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("그룹 이름")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .foregroundColor(Color.Gray_495057)
            
            TextField("", text: $createGroupModel.groupName)
                .font(.custom(CustomFont.RobotoRegular.rawValue, size: 30))
                .overlay(SimpleBottomLine(color: Color.Gray_DEE2E6))
                .focused($focusField, equals: .groupName)
        }
        .onTapGesture {
            focusField = .groupName
        }
    }
    
    @ViewBuilder
    func Tag() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("태그")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .foregroundColor(Color.Gray_495057)
            
            BottomLineTextfield(placeholder: "#렌탈 #서비스는 #REN2U", placeholderLocation: .leading,
                                placeholderSize: 18, isConfirmed: .constant(false), text: $createGroupModel.tagsText)
            .onSubmit {
                createGroupModel.printUTF8Length(tag: createGroupModel.tagsText)
            }
            
            Text("#과 띄어쓰기를 포함해 영어는 최대 36글자, 한글은 24글자까지 가능합니다.")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .foregroundColor(Color.Gray_ADB5BD)
                .padding(.top, -20)
        }
    }
    
    @ViewBuilder
    func Introduction() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("소개글")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .foregroundColor(Color.Gray_495057)
            
            TextEditor(text: $createGroupModel.introduction)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .frame(height: 100)
                .overlay{
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.Gray_DEE2E6, lineWidth: 2)
                }
            
            Text("띄어쓰기 포함 한글 130글자, 영어 150글자까지 가능합니다.")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .foregroundColor(Color.Gray_495057)
        }
    }
    
    @ViewBuilder
    func ChangeImageButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    Text("사진 변경")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        .foregroundColor(.LabelColor)
                        .padding(.horizontal, 10)
                }

            }
        }
    }
    
    @ViewBuilder
    func CreateCompleteButton() -> some View {
        
    }
}

struct CreateGroup_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroup()
    }
}
