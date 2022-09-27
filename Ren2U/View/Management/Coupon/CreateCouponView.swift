//
//  CreateCouponView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/21.
//

import SwiftUI
import Kingfisher

struct CreateCouponView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationManager: LocationManager
    
    @StateObject var dateVM = DateViewModel()
    @StateObject var createCouponVM: CreateCouponViewModel
    @ObservedObject var couponVM: CouponViewModel
    @ObservedObject var couponDetailAdminVM: CouponDetailAdminViewModel
    @State private var isShowingImagePicker = false
    
    // post에 사용
    init(clubId: Int, couponVM: ObservedObject<CouponViewModel>, method: Method, couponDetailAdminVM: CouponDetailAdminViewModel) {
        self._createCouponVM = StateObject(wrappedValue: CreateCouponViewModel(clubId: clubId, method: method))
        self._couponVM = couponVM
        self._couponDetailAdminVM = ObservedObject(wrappedValue: couponDetailAdminVM)
    }
    
    // put에 사용
    init(clubId: Int, couponId: Int, couponDetailData: CouponDetailAdminData, couponVM: ObservedObject<CouponViewModel>, method: Method, couponDetailAdminVM: CouponDetailAdminViewModel) {
        self._createCouponVM = StateObject(wrappedValue: CreateCouponViewModel(clubId: clubId, couponId: couponId, couponDetailAdminData: couponDetailData, method: method))
        self._couponVM = couponVM
        self._couponDetailAdminVM = ObservedObject(wrappedValue: couponDetailAdminVM)
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                
                VStack(alignment: .center, spacing: 10) {
                    CouponImage(url: createCouponVM.coupon.imagePath, size: 200)
                    ChangeImageButton()
                }
                .frame(maxWidth: .infinity)
                
                CouponName()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("사용가능 기한")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                        .foregroundColor(.gray_495057)
                    
                    RentalDatePicker(viewModel: dateVM)
                        .padding(.horizontal, 30)
                        .onChange(of: dateVM.startDate) { createCouponVM.coupon.actDate = $0 }
                        .onChange(of: dateVM.endDate) { createCouponVM.coupon.expDate = $0 }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 10) {
                    Text("사용가능 기한 확인")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                        .foregroundColor(.gray_495057)

                    Text(createCouponVM.coupon.period)
                        .font(.custom(CustomFont.RobotoMedium.rawValue, size: 24))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                UseLocation()
                Information()
            }
        }
        .padding(.horizontal, 10)
        .sheet(isPresented: $isShowingImagePicker) {
            UpdatedImagePicker(imagePath: $createCouponVM.coupon.imagePath)
        }
        .basicNavigationTitle(title: "쿠폰 등록")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    createCouponVM.showMethodAlert()
                } label: {
                    Text("완료")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                }
            }
        }
        .alert(createCouponVM.callbackAlert.title, isPresented: $createCouponVM.callbackAlert.isPresented) {
            Button("취소", role: .cancel) {}
            Button("확인") {
                Task {
                    await createCouponVM.callbackAlert.callback()
                    couponVM.getClubCouponsAdmin()
                    dismiss()
                    
                    if createCouponVM.method == .put {
                        await couponDetailAdminVM.getCouponAdmin()
                    }
                }
            }
        } message: {
            createCouponVM.callbackAlert.message
        }
        .alert(createCouponVM.oneButtonAlert.title, isPresented: $createCouponVM.oneButtonAlert.isPresented) {
            OneButtonAlert.noActionButton
        } message: {
            createCouponVM.oneButtonAlert.message
        }

    }
    
    @ViewBuilder
    private func ChangeImageButton() -> some View {
        Button {
            if locationManager.requestAuthorization() {
                isShowingImagePicker = true
            }
        } label: {
            Text("사진 변경")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
        }
    }
    
    @ViewBuilder
    private func CouponName() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("쿠폰 이름")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
            
            TextField("", text: $createCouponVM.coupon.name)
                .background(alignment: .bottom) {
                    SimpleLine(color: Color.gray_DEE2E6)
                }
        }
    }
    
    @ViewBuilder private func UseLocation() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("사용가능 위치")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
            
            TextField("", text: $createCouponVM.coupon.location)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                .background(alignment: .bottom) {
                    SimpleLine(color: Color.gray_DEE2E6)
                }
            
            Button {
                createCouponVM.isShowingLocationPicker = true
            } label: {
                GrayRoundedRectangle(bgColor: createCouponVM.coupon.showMapButtonBGColor, fgColor: createCouponVM.coupon.showMapButtonFGColor, text: "지도에서 장소 표시")
            }
            .background(
                NavigationLink(isActive: $createCouponVM.isShowingLocationPicker) {
                    CouponLocationView(createCouponVM: createCouponVM)
                } label: { }
            )

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder private func Information() -> some View {
        
        VStack(alignment: .leading, spacing: 10) {
           Text("세부정보")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
            
            TextEditor(text: $createCouponVM.coupon.information)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .padding(.all, 5)
                .frame(maxHeight: .infinity)
                .background(RoundedCorner(radius: 8, corners: .allCorners).stroke(Color.gray_F1F2F3))
                .padding(.horizontal, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//struct CreateCouponView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateCouponView()
//    }
//}
