//
//  CouponDetailView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI

struct CouponTitle: Title {
    var title: [String] = ["미사용", "사용완료"]
    
    func getTitleOffset(title: String) -> Int {
        var value = 0
        for i in 0..<self.title.count {
            if self.title[i] == title {
                value = i
            }
        }
        return value
    }
    
    func getTitleColor(title: String, index: Int) -> Color {
        if self.title[index] == title {
            return Color.navy_1E2F97
        } else {
            return Color.gray_ADB5BD
        }
    }
    
    
}

struct CouponDetailView: View {
    
    @ObservedObject var couponVM: CouponViewModel
    @ObservedObject var managementVM: ManagementViewModel
    let couponTitle = CouponTitle()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                
                CouponImage(url: couponVM.couponDetailData?.imagePath ?? "", size: 200)
                CouponCount()
                Period()
                Location()
                Information()
                GrantCoupon()
                
                TitleSelector(titles: couponVM.couponTitle, selectedTitle: $couponVM.selectedTitle)
                
                UnusedCouponMembers()
                    .isHidden(hidden: couponVM.selectedTitle != couponVM.couponTitle.title[0])
                UsedCouponMebers()
                    .isHidden(hidden: couponVM.selectedTitle != couponVM.couponTitle.title[1])
                

            }
            .padding(.horizontal)
        }
        .basicNavigationTitle(title: couponVM.couponDetailData?.name ?? "")
        .avoidSafeArea()
        .onDisappear {
            couponVM.couponDetailData = nil
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    CreateCouponView(clubId: couponVM.clubId, couponId: couponVM.couponId, couponDetailData: couponVM.couponDetailData ?? CouponDetailAdminData.dummyData(), couponVM: _couponVM, method: .put)
                } label: {
                    Text("수정")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                }
            }
        }
    }
    
    @ViewBuilder
    private func CouponCount() -> some View {
        Group {
            HStack {
                Text("발급 수")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.gray_495057)
                
                Spacer()
                
                Text("\(couponVM.couponDetailData?.allCouponCount ?? 0)장")
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
            }
            
            HStack {
                Text("미사용 쿠폰")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.gray_495057)
                
                Spacer()
                
                Text("\(couponVM.couponDetailData?.leftCouponCount ?? 0)장")
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
            }
        }
    }
    
    @ViewBuilder
    private func Period() -> some View {
        HStack {
            Text("사용가능 기한")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(.gray_495057)
            
            Spacer()
            
            Text(couponVM.couponDetailData?.period ?? "")
                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
        }
    }
    
    @ViewBuilder
    private func Location() -> some View {
        HStack {
            Text("사용가능 위치")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(.gray_495057)
            
            Spacer()
            
            Text(couponVM.couponDetailData?.location.name ?? "")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
        }
    }
    
    @ViewBuilder
    private func Information() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("세부정보")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(.gray_495057)
                .frame(maxWidth: .infinity)
            
            Text(couponVM.couponDetailData?.information ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .padding(.vertical, 5)
                .padding(.horizontal, 5)
                .background(RoundedCorner(radius: 10, corners: .allCorners).fill(Color.gray_E9ECEF))
        }
    }
    
    @ViewBuilder
    private func GrantCoupon() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("쿠폰 발급")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(.gray_495057)
            
            NavigationLink {
                GrantCouponView(managementVM: managementVM, couponVM: couponVM)
            } label: {
                GrayRoundedRectangle(bgColor: Color.gray_F1F2F3, fgColor: Color.black, text: "멤버선택")
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func UnusedCouponMembers() -> some View {
        VStack {
            ForEach(couponVM.couponMembers.indices, id: \.self) { i in
                CouponMemberCell(memberInfo: couponVM.couponMembers[i].memberPreviewDto)
                
                Divider()
                    .padding(.horizontal, -10)
            }
        }
    }
    
    @ViewBuilder
    private func UsedCouponMebers() -> some View {
        VStack {
            ForEach(couponVM.couponeMebersHistories.indices, id: \.self) { i in
                CouponMemberCell(memberInfo: couponVM.couponeMebersHistories[i].memberPreviewDto)
                
                
                Divider()
                    .padding(.horizontal, -10)
            }
        }
    }
}

//struct CouponDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        CouponDetailView()
//    }
//}
