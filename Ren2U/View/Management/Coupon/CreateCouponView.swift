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
    @StateObject var createCouponVM: CreateCouponViewModel
    @State private var isShowingImagePicker = false
    @EnvironmentObject var locationManager: LocationManager
    
    init(clubId: Int) {
        self._createCouponVM = StateObject(wrappedValue: CreateCouponViewModel(clubId: clubId))
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
                    
                    
                    if #available(iOS 16.0, *) {
                        MultiDatePicker("Dates", selection: $createCouponVM.dates)
                    }
//                    DatePicker(selection: $createCouponVM.coupon.actDate) {
//                        EmptyView()
//                    }
//
//                    DatePicker(selection: $createCouponVM.coupon.expDate) {
//                        EmptyView()
//                    }
//                    RentalDatePicker(viewModel: DateViewModel(startDate: $createCouponVM.coupon.actDate, endDate: $createCouponVM.coupon.expDate))
//                        .padding(.horizontal, 30)

                }
                .frame(maxWidth: .infinity, alignment: .leading)

//                VStack(alignment: .leading, spacing: 10) {
//                    Text("사용가능 기한 확인")
//                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
//                        .foregroundColor(.gray_495057)
//
//                    Text("\(createCouponVM.coupon.actDate.toJsonValue() ?? "") ~ \(createCouponVM.coupon.expDate.toJsonValue() ?? "")")
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)

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
                    createCouponVM.showAlertPostCouponAdmin()
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
            
            EditorPlaceholder(placeholder: "", text: $createCouponVM.coupon.information)
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
