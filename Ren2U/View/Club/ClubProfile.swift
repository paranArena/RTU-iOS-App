//
//  CreateGroup.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//  텍스트 필드 변경 감지 : https://stackoverflow.com/questions/58406224/how-to-detect-when-a-textfield-loses-the-focus-in-swiftui-for-ios

import SwiftUI
import HidableTabView
import Kingfisher
import ObservedOptionalObject

struct ClubProfile: View {
    
    @EnvironmentObject var clubVM: ClubViewModel
    @EnvironmentObject var imagePickerVM: ImagePickerViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.isPresented) var isPresented
    @StateObject private var clubProfileVM: ClubProfileViewModel
    @FocusState var focusField: ClubField?
    
    
    init(clubProfileService: ClubProfileViewModel) {
        self._clubProfileVM = StateObject(wrappedValue: clubProfileService)
    }
    

    var body: some View {
        BounceControllScrollView(baseOffset: 80, offset: $clubProfileVM.offset) {
            VStack(alignment: .center, spacing: 10) {
                GroupImage()
                    .overlay(ChangeImageButton())
                    
                VStack(alignment: .leading, spacing: 70) {
                    GroupName()
                    Tags()
                    Introduction()
                }
                .padding(.horizontal, 10)
                
            }
            .animation(.spring(), value: focusField)
        }
        .alert(clubProfileVM.alert.titleText, isPresented: $clubProfileVM.alert.isPresentedAlert, actions: {
            if clubProfileVM.alert.isPresentedCancelButton {
                CustomAlert.CancelButton
            }
            Button("확인") { Task {
                await clubProfileVM.alert.callback()
            }}
        }, message: {
            clubProfileVM.alert.message
        })
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
        if clubProfileVM.mode == .post {
            if let uiImage = clubProfileVM.selectedUIImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: SCREEN_WIDTH, height: 215)
            } else {
                Image("DefaultGroupImage")
                    .resizable()
                    .frame(width: SCREEN_WIDTH, height: 215)
            }
        } else {
            KFImage(URL(string: clubProfileVM.clubProfileParam.imagePath))
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
        }
    }
    
    @ViewBuilder
    private func GroupName() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("그룹 이름")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .foregroundColor(Color.gray_495057)
            
            TextField("", text: $clubProfileVM.clubProfileParam.name)
                .font(.custom(CustomFont.RobotoRegular.rawValue, size: 30))
                .overlay(SimpleBottomLine(color: Color.gray_DEE2E6))
                .submitLabel(.next)
                .focused($focusField, equals: .groupName)
                .onSubmit {
                    clubProfileVM.isShowingTagPlaceholder = false
                    focusField = .tagsText
                }
        }
        .isHidden(hidden: (focusField != nil && focusField != .groupName))
        .onTapGesture {
            focusField = .groupName
        }
    }  
    
    @ViewBuilder
    private func Tags() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                Text("태그")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    .foregroundColor(Color.gray_495057)
                
                ZStack(alignment: .leading) {
                    
                    Text("#렌탈 #서비스는 #REN2U")
                        .foregroundColor(.gray_ADB5BD)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
                        .isHidden(hidden: !clubProfileVM.isShowingTagPlaceholder)
                    
                    TextField("", text: $clubProfileVM.clubProfileParam.hashtagText)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
                        .focused($focusField, equals: .tagsText)
                        .submitLabel(.return)
                        .onChange(of: focusField) { newValue in
                            clubProfileVM.hashtagEditEnded()
//                            viewModel.showTagPlaceHolder(newValue: newValue)
                        }
                }
                .overlay(alignment: .bottom) { SimpleLine(color: Color.gray_ADB5BD) } 
                
                Text("#과 띄어쓰기를 포함해 영어는 최대 36글자, 한글은 24글자까지 가능합니다.")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                    .foregroundColor(Color.gray_ADB5BD)
                    .padding(.top, -10)
            }
            .onTapGesture {
                focusField = .tagsText
                clubProfileVM.isShowingTagPlaceholder = false
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(clubProfileVM.clubProfileParam.hashtags.indices, id: \.self) { i in
                        HStack {
                            Text("#\(clubProfileVM.clubProfileParam.hashtags[i])")
                                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                            
                            Button {
                                clubProfileVM.xmarkTapped(index: i)
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                            }
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .overlay(Capsule().stroke(lineWidth: 1))
                    }
                }
                .foregroundColor(Color.gray_495057)
            }
        }
        .isHidden(hidden: (focusField != nil && focusField != .tagsText))
    }
    
    @ViewBuilder
    private func Introduction() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("소개글")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .foregroundColor(Color.gray_495057)
            
            TextEditor(text: $clubProfileVM.clubProfileParam.introduction)
                .focused($focusField, equals: .introduction)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .frame(height: 100)
                .overlay{
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray_DEE2E6, lineWidth: 2)
                }
            
            Text("띄어쓰기 포함 한글 130글자, 영어 150글자까지 가능합니다.")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
                .foregroundColor(Color.gray_495057)
        }
        .isHidden(hidden: (focusField != nil && focusField != .introduction))
        .onTapGesture {
            focusField = .introduction
        }
        .animation(.spring(), value: clubProfileVM.clubProfileParam.hashtags)
    }
    
    @ViewBuilder
    private func ChangeImageButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    imagePickerVM.showDialog()
                } label: {
                    Text("사진 변경")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        .foregroundColor(.BackgroundColor)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 5)
                }
            }
        }
        .sheet(isPresented: $imagePickerVM.isShowingPicker) {
            UpdatedImagePickerView(sourceType: imagePickerVM.source == .library ? .photoLibrary : .camera, selectedImage: $clubProfileVM.selectedUIImage, imagePath: $clubProfileVM.clubProfileParam.imagePath)
                  .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func CreateCompleteButton() -> some View {
        Button {
            Task {
                await clubProfileVM.completeButtonTapped{
                    dismiss()
                    clubVM.getMyClubs()
                }
            }
        } label: {
            Text("완료")
                .foregroundColor(Color.LabelColor)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
        }
    }
}

//struct CreateGroup_Previews: PreviewProvider {
//    static var previews: some View {
//        ClubProfile(viewModel: ClubProfile.ViewModel(mode: ClubProfile.Mode.post))
//    }
//}
