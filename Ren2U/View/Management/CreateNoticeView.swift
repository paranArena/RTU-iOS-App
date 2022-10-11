//
//  CreateNoticeView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI
import Kingfisher

struct CreateNoticeView: View {
    
    
    @State private var isShowingImagePicker = false
    @State private var isShowingAlert = false
    
    @ObservedObject var managementVM: ManagementViewModel
    @StateObject var notificationVM: CreateNotificationViewModel
    @EnvironmentObject var groupVM: ClubViewModel
    @Environment(\.dismiss) var dismiss
    
    // post
    init(method: Method, clubId: Int, managementVM: ManagementViewModel) {
        self._notificationVM = StateObject(wrappedValue: CreateNotificationViewModel(clubId: clubId, method: method))
        self.managementVM = managementVM
    }
    
    // put
    init(method: Method, clubId: Int, notificationId: Int, managementVM: ManagementViewModel) {
        self._notificationVM = StateObject(wrappedValue:
                                            CreateNotificationViewModel(clubId: clubId, notificationId: notificationId,
                                                                        method: method))
        self.managementVM = managementVM
    }
    
    var body: some View {
        VStack {
            TextField("제목을 입력해주세요", text: $notificationVM.notificationParam.title)
                .padding(.top, 20)
            Divider()
            
            
            HStack {
                ImagePickerButton()
                KFImage(URL(string: notificationVM.notificationParam.imagePath))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(15)
                    .isHidden(hidden: notificationVM.notificationParam.imagePath.isEmpty)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
            .padding(.bottom, 5)
            
            EditorPlaceholder(placeholder: "내용을 입력해주세요", text: $notificationVM.notificationParam.content)
        }
        .padding(.horizontal, 10)
        .basicNavigationTitle(title: "공지사항 등록")
        .alert("제목과 내용은 필수입니다.", isPresented: $isShowingAlert) {
            Button("확인", role: .cancel) {}
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if notificationVM.notificationParam.title.isEmpty || notificationVM.notificationParam.content.isEmpty {
                        isShowingAlert = true
                    } else {
                        
                        if notificationVM.method == .post {
                            Task {
                                await notificationVM.createNotification()
                                managementVM.searchNotificationsAll()
                                groupVM.getMyNotifications()
                                dismiss()
                            }
                        } else {
                            notificationVM.showUpdateNoficiationAlert()
                        }

                    }
                } label: {
                    Text("완료")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            UpdatedImagePicker(imagePath: $notificationVM.notificationParam.imagePath)
        }
        .avoidSafeArea()
        .alert(notificationVM.callbackAlert.title, isPresented: $notificationVM.callbackAlert.isPresented) {
            Button(role: .cancel) {
                
            } label: {
                Text("취소")
            }
            
            Button("확인") { Task{
                await notificationVM.callbackAlert.callback()
                managementVM.searchNotificationsAll()
                groupVM.getMyNotifications()
                dismiss()
            }}
        } message: {
            notificationVM.callbackAlert.message
        }
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
                .padding(.vertical, 20)
        }
        .padding(.horizontal, 20)
        .frame(width: 80, height: 80)
        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray_ADB5BD, lineWidth: 2))
    }
}

//struct CreateNoticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNoticeView()
//    }
//}
