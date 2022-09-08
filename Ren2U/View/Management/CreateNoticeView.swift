//
//  CreateNoticeView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI

struct CreateNoticeView: View {
    
    @State private var raw = NotificationModel(title: "", content: "")
    
    @State private var isShowingImagePicker = false
    @State private var isShowingImage = false
    
    @ObservedObject var managementVM: ManagementViewModel
    @EnvironmentObject var groupVM: ClubViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TextField("제목을 입력해주세요", text: $raw.title)
                .padding(.top, 20)
            Divider()
            
            EditorPlaceholder(placeholder: "내용을 입력해주세요", text: $raw.content)
            
            Spacer()
            
            
            
            HStack {
                
                Button {
                    isShowingImage = true
                } label: {
                    if let image = raw.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .cornerRadius(15)
                    }
                }
                
                Spacer()
                
                ImagePickerButton()
            }
        }
        .padding(.horizontal, 10)
        .basicNavigationTitle(title: "공지사항 등록")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await managementVM.createNotification(notice: raw)
                        managementVM.searchNotificationssAll()
                        groupVM.getMyNotifications()
                    }
                    dismiss()
                } label: {
                    Text("완료")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $raw.image)
        }
        .sheet(isPresented: $isShowingImage) {
            Image(uiImage: raw.image!)
                .resizable()
                .scaledToFill()
                .frame(width: SCREEN_WIDTH, height: SCREEN_WIDTH)
                .cornerRadius(30)
                
        }
        .avoidSafeArea()
    }
    
    @ViewBuilder
    private func ImagePickerButton() -> some View{
        Button {
            isShowingImagePicker = true
        } label: {
            Image(systemName: "camera")
                .resizable()
                .foregroundColor(.gray_ADB5BD)
                .frame(width: 30, height: 30)
        }
        .padding(.horizontal, 20)
    }
}

//struct CreateNoticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNoticeView()
//    }
//}
