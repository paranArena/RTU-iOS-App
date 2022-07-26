//
//  CreateGroup.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//  텍스트 필드 변경 감지 : https://stackoverflow.com/questions/58406224/how-to-detect-when-a-textfield-loses-the-focus-in-swiftui-for-ios

import SwiftUI

struct CreateGroup: View {
    
    @Environment(\.presentationMode) var presentationMode
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
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("그룹등록")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
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
                .onSubmit {
                    createGroupModel.isShowingTagPlaceholder = false
                    focusField = .tagsText
                }
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
            
            ZStack(alignment: .leading) {
                if createGroupModel.isShowingTagPlaceholder {
                    Text("#렌탈 #서비스는 #REN2U")
                        .foregroundColor(.Gray_ADB5BD)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
                }
                
                TextField("", text: $createGroupModel.tagsText)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
                    .focused($focusField, equals: .tagsText)
                    .onChange(of: focusField) { newValue in
                        createGroupModel.parsingTag()
                        createGroupModel.showTagPlaceHolder(newValue: newValue)
                    }
            }
            .overlay(
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.Gray_ADB5BD)
                }
            )
            
            Text("#과 띄어쓰기를 포함해 영어는 최대 36글자, 한글은 24글자까지 가능합니다.")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .foregroundColor(Color.Gray_ADB5BD)
                .padding(.top, -10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(createGroupModel.tags) { tag in
                        Text(tag.tag)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                            .overlay(Capsule().stroke(lineWidth: 1))
                    }
                }
                .foregroundColor(Color.Gray_495057)
            }
        }
        .onTapGesture {
            focusField = CreateGroupField.tagsText
            createGroupModel.isShowingTagPlaceholder = false
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
        .animation(.spring(), value: createGroupModel.tags)
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
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("완료")
        }

    }
}

struct CreateGroup_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroup()
    }
}
