//
//  ProfileManagement .swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/04.
//

import SwiftUI
import Kingfisher

struct ProfileManagement: View {
    
    @ObservedObject var managementVM: ManagementViewModel
    @State private var offset: CGFloat = .zero
    var body: some View {
        BounceControllScrollView(baseOffset: 20, offset: $offset) {
            VStack {
                if let imagePath = managementVM.clubData.thumbnailPath {
                    KFImage(URL(string: imagePath))
                } else {
                    Image(AssetImages.DefaultGroupImage.rawValue)
                }
            }
        }
        .basicNavigationTitle(title: "프로필 수정")
        .onAppear {
            UITabBar.hideTabBar()
        }
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

struct ProfileManagement__Previews: PreviewProvider {
    static var previews: some View {
        ProfileManagement(managementVM: ManagementViewModel(clubData: ClubData.dummyClubData()))
    }
}
