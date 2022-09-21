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
    @ObservedObject var couponVM: CouponViewModel
    @State private var isShowingImagePicker = false
    @EnvironmentObject var locationManager: LocationManager
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                
                VStack(alignment: .center, spacing: 10) {
                    CouponImage(url: couponVM.coupon.imagePath)
                    ChangeImageButton()
                }
                .frame(maxWidth: .infinity)
                
                CouponName()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("사용가능 기한")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                        .foregroundColor(.gray_495057)
                    
                    RentalDatePicker(viewModel: DateViewModel(startDate: $couponVM.coupon.actDate, endDate: $couponVM.coupon.expDate))
                        .padding(.horizontal, 30)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("사용가능 기한 확인")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                        .foregroundColor(.gray_495057)
                    
                    Text("\(couponVM.coupon.actDate?.toJsonValue() ?? "") ~ \(couponVM.coupon.expDate?.toJsonValue() ?? "")")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                UseLocation()
                Information()
            }
        }
        .padding(.horizontal, 10)
        .sheet(isPresented: $isShowingImagePicker) {
            UpdatedImagePicker(imagePath: $couponVM.coupon.imagePath)
        }
        .basicNavigationTitle(title: "쿠폰 등록")
        .onDisappear {
            couponVM.clearCouponParam()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    couponVM.showAlertPostCouponAdmin()
                } label: {
                    Text("완료")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                }
            }
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
            
            TextField("", text: $couponVM.coupon.name)
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
            
            TextField("", text: $couponVM.coupon.location)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                .background(alignment: .bottom) {
                    SimpleLine(color: Color.gray_DEE2E6)
                }
            
            Button {
                couponVM.isShowingLocationPikcer = true
            } label: {
                ShowMapLabel(bgColor: couponVM.coupon.showMapButtonBGColor, fgColor: couponVM.coupon.showMapButtonFGColor)
            }
//            .background(
//                NavigationLink(isActive: $couponVM.isShowingLocationPikcer) {
//                    CouponLocationView(couponVM: couponVM)
//                } label: { }
//            )

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder private func Information() -> some View {
        
        VStack(alignment: .leading, spacing: 10) {
           Text("세부정보")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
            
            EditorPlaceholder(placeholder: "", text: $couponVM.coupon.information)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//struct CreateCouponView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateCouponView()
//    }
//}
