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

struct CouponDetailAdminView: View {
    
    @ObservedObject var managementVM: ManagementViewModel
    @ObservedObject var couponVM: CouponViewModel
    @StateObject var couponDetailAdminVM: CouponDetailAdminViewModel
    
    init(managementVM: ObservedObject<ManagementViewModel>, couponVM: ObservedObject<CouponViewModel>, clubId: Int, couponId: Int) {
        self._managementVM = managementVM
        self._couponVM = couponVM
        self._couponDetailAdminVM = StateObject(wrappedValue: CouponDetailAdminViewModel(clubId: clubId, couponId: couponId))
    }
    let couponTitle = CouponTitle()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                
                CouponImage(url: couponDetailAdminVM.couponDetailData?.imagePath ?? "", size: 200)
                CouponCount()
                Period()
                Location()
                Information()
                GrantCoupon()
                
                TitleSelector(titles: couponDetailAdminVM.couponTitle, selectedTitle: $couponDetailAdminVM.selectedTitle)
                
                UnusedCouponMembers()
                    .isHidden(hidden: couponDetailAdminVM.selectedTitle != couponDetailAdminVM.couponTitle.title[0])
                UsedCouponMebers()
                    .isHidden(hidden: couponDetailAdminVM.selectedTitle != couponDetailAdminVM.couponTitle.title[1])
                

            }
            .padding(.horizontal, 10)
        }
        .basicNavigationTitle(title: couponDetailAdminVM.couponDetailData?.name ?? "")
        .avoidSafeArea()
        .alert("", isPresented: $couponDetailAdminVM.callbackAlert.isPresented) {
            Button("취소", role: .cancel) {}
            Button("확인") { Task { await couponDetailAdminVM.callbackAlert.callback() }}
        } message: {
            couponDetailAdminVM.callbackAlert.message
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    CreateCouponView(clubId: couponDetailAdminVM.clubId, couponId: couponDetailAdminVM.couponId, couponDetailData: couponDetailAdminVM.couponDetailData ?? CouponDetailAdminData.dummyData(), couponVM: _couponVM, method: .put, couponDetailAdminVM: couponDetailAdminVM)
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
                
                Text("\(couponDetailAdminVM.couponDetailData?.allCouponCount ?? 0)장")
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
            }
            
            HStack {
                Text("미사용 쿠폰")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(.gray_495057)
                
                Spacer()
                
                Text("\(couponDetailAdminVM.couponDetailData?.leftCouponCount ?? 0)장")
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
            
            Text(couponDetailAdminVM.couponDetailData?.period ?? "")
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
            
            Text(couponDetailAdminVM.couponDetailData?.location.name ?? "")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
        }
    }
    
    @ViewBuilder
    private func Information() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("세부정보")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(.gray_495057)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(couponDetailAdminVM.couponDetailData?.information ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .padding(.vertical, 5)
                .padding(.horizontal, 5)
                .background(RoundedCorner(radius: 5, corners: .allCorners).fill(Color.gray_E9ECEF))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func GrantCoupon() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("쿠폰 발급")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(.gray_495057)
            
            NavigationLink {
                GrantCouponView(managementVM: managementVM, couponDetailAdminVM: couponDetailAdminVM)
            } label: {
                GrayRoundedRectangle(bgColor: Color.gray_F1F2F3, fgColor: Color.black, text: "멤버선택")
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func UnusedCouponMembers() -> some View {
        VStack {
            SwipeResettableView(selectedCellId: $couponDetailAdminVM.selectedUnsedCouponId) {
                ForEach(couponDetailAdminVM.couponMembers.indices, id: \.self) { i in
                    UnusedCouponCell(couponDetailAdminVM: couponDetailAdminVM, data: couponDetailAdminVM.couponMembers[i])
                        .padding(.leading, 10)
                    
                    Divider()
                }
            }
        }
        .padding(.horizontal, -10)
    }
    
    @ViewBuilder
    private func UsedCouponMebers() -> some View {
        VStack {
            ForEach(couponDetailAdminVM.couponeMebersHistories.indices, id: \.self) { i in
                CouponMemberCell(data: couponDetailAdminVM.couponeMebersHistories[i].memberPreviewDto)
                
                
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
