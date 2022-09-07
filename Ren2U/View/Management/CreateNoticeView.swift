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
    @ObservedObject var managementVM: ManagementViewModel
    @EnvironmentObject var groupVM: ClubViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TextField("제목을 입력해주세요", text: $raw.title)
                .padding(.top, 20)
            Divider()
            
            EditorPlaceholder(placeholder: "내용을 입력해주세요", text: $raw.content)
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
        .overlay(
            ImagePickerButton()
        )
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $raw.image)
        }
    }
    
    @ViewBuilder
    private func ImagePickerButton() -> some View{
        VStack {
            Spacer()
            
            Button {
                isShowingImagePicker = true
            } label: {
                Image(systemName: "camera")
                    .resizable()
                    .foregroundColor(.gray_ADB5BD)
                    .frame(width: 24, height: 24)
            }
        }
        .frame(width: SCREEN_WIDTH, alignment: .leading)
        .padding(.leading, 20)
        .padding(.bottom, SAFE_AREA_BOTTOM_HEIGHT)
        .ignoresSafeArea(.all, edges: .bottom)
        .overlay(ShadowRectangle())
    }
}

//struct CreateNoticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNoticeView()
//    }
//}
