//
//  NoticeManagement.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import SwiftUI
import HidableTabView

struct NoticeManagement: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("공지사항")
                Text("공지사항")
                Text("공지사항")
                Text("공지사항")
                Text("공지사항")
                Text("공지사항")
                Text("공지사항")
                Text("공지사항")
                Text("공지사항")
                Text("공지사항")
            }
        }
        .basicNavigationTitle(title: "공지사항")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink {
                        CreateNoticeView()
                    } label: {
                        PlusCircle()
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .onAppear {
            UITabBar.hideTabBar()
        }
    }
}

struct NoticeManagement_Previews: PreviewProvider {
    static var previews: some View {
        NoticeManagement()
    }
}
