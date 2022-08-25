//
//  CreateGroup.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//  텍스트 필드 변경 감지 : https://stackoverflow.com/questions/58406224/how-to-detect-when-a-textfield-loses-the-focus-in-swiftui-for-ios

import SwiftUI
import HidableTabView

struct CreateGroup: View {
    
    @EnvironmentObject var groupViewModel: GroupViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.isPresented) var isPresented
    @StateObject var viewModel = ViewModel()
    @FocusState var focusField: Field?

    var body: some View {
        BounceControllScrollView(offset: $viewModel.offset) {
            VStack(alignment: .center, spacing: 10) {
                GroupImage()
                    .overlay(ChangeImageButton())
                    
                VStack(alignment: .leading, spacing: 70) {
                    GroupName()
                    Tag()
                    Introduction()
                }
                .padding(.horizontal, 10)
                
            }
            .animation(.spring(), value: focusField)
        }
        .controllTabbar(isPresented)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: {
            UITabBar.showTabBar(animated: false)
        })
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("그룹등록")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                CreateCompleteButton()
            }
        }
    }
    
    @ViewBuilder
    private func GroupImage() -> some View {
        if let uiImage = viewModel.selectedUIImage {
            Image(uiImage: uiImage)
                .resizable()
                .frame(width: SCREEN_WIDTH, height: 215)
        } else {
            Image("DefaultGroupImage")
                .resizable()
                .frame(width: SCREEN_WIDTH, height: 215)
        }
    }
    
    @ViewBuilder
    private func GroupName() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("그룹 이름")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .foregroundColor(Color.Gray_495057)
            
            TextField("", text: $viewModel.groupName)
                .font(.custom(CustomFont.RobotoRegular.rawValue, size: 30))
                .overlay(SimpleBottomLine(color: Color.gray_DEE2E6))
                .submitLabel(.next)
                .focused($focusField, equals: .groupName)
                .onSubmit {
                    viewModel.isShowingTagPlaceholder = false
                    focusField = .tagsText
                }
        }
        .overlay(ChangeImageButton())
        .isHidden(hidden: (focusField != nil && focusField != .groupName))
        .onTapGesture {
            focusField = .groupName
        }
    }  
    
    @ViewBuilder
    private func Tag() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("태그")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .foregroundColor(Color.Gray_495057)
            
            ZStack(alignment: .leading) {
                if viewModel.isShowingTagPlaceholder {
                    Text("#렌탈 #서비스는 #REN2U")
                        .foregroundColor(.gray_ADB5BD)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
                }
                
                TextField("", text: $viewModel.tagsText)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
                    .focused($focusField, equals: .tagsText)
                    .submitLabel(.return)
                    .onChange(of: focusField) { newValue in
                        viewModel.parsingTag()
                        viewModel.showTagPlaceHolder(newValue: newValue)
                    }
            }
            .overlay(
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray_ADB5BD)
                }
            )
            
            Text("#과 띄어쓰기를 포함해 영어는 최대 36글자, 한글은 24글자까지 가능합니다.")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .foregroundColor(Color.gray_ADB5BD)
                .padding(.top, -10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.tags) { tag in
                        Text("\(tag.tag)")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                            .overlay(Capsule().stroke(lineWidth: 1))
                    }
                }
                .foregroundColor(Color.Gray_495057)
            }
        }
        .isHidden(hidden: (focusField != nil && focusField != .tagsText))
        .onTapGesture {
            focusField = .tagsText
            viewModel.isShowingTagPlaceholder = false
        }
        
    }
    
    @ViewBuilder
    private func Introduction() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("소개글")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .foregroundColor(Color.Gray_495057)
            
            TextEditor(text: $viewModel.introduction)
                .focused($focusField, equals: .introduction)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .submitLabel(.done)
                .frame(height: 100)
                .overlay{
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray_DEE2E6, lineWidth: 2)
                }
            
            Text("띄어쓰기 포함 한글 130글자, 영어 150글자까지 가능합니다.")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .foregroundColor(Color.Gray_495057)
        }
        .isHidden(hidden: (focusField != nil && focusField != .introduction))
        .onTapGesture {
            focusField = .introduction
        }
        .animation(.spring(), value: viewModel.tags)
    }
    
    @ViewBuilder
    private func ChangeImageButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    viewModel.showImagePicker.toggle()
                } label: {
                    Text("사진 변경")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        .foregroundColor(.BackgroundColor)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 5)
                }
//                .sheet(isPresented: $viewModel.showImagePicker) {
//                    ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.selectedUIImage?)
//                        .ignoresSafeArea(.all)
//                }
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.selectedUIImage)
        }
    }
    
    @ViewBuilder
    private func CreateCompleteButton() -> some View {
        Button {
            groupViewModel.taskCreateClub(club: TempGroupInfo(name: viewModel.groupName, introduction: viewModel.introduction))
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("완료")
                .foregroundColor(Color.LabelColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
        }
    }
}

struct CreateGroup_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroup()
    }
}
