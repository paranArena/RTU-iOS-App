//
//  CreateNoticeView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI

struct CreateNoticeView: View {
    
    @State private var raw = NotificationModel(title: "", content: "")
    
    var body: some View {
        VStack {
            TextField("제목을 입력해주세요", text: $raw.title)
                .padding(.top, 20)
            Divider()
            
            SimplePlaceholderEditor(placeholder: "내용을 입력해주세요", text: $raw.content)
        }
        .padding(.horizontal, 10)
        .basicNavigationTitle(title: "공지사항 등록")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Text("완료")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                }

            }
        }
    }
}

struct CreateNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNoticeView()
    }
}