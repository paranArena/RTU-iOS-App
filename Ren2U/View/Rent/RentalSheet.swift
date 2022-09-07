//
//  RentalDetail.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/10.
//

import SwiftUI

struct RentalSheet: View {
    
    let itemInfo: ProductResponseData
    @StateObject var viewModel = ViewModel()
    @Binding var isRentalTerminal: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                ItemPicker()
                
                RentalDatePicker(viewModel: viewModel)
                    .padding(.horizontal, 10)
                
                Text("대여기간 확인")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                
                HStack(alignment: .center, spacing: 0) {
                    Text(viewModel.startDateString)
                    Text(viewModel.endDateString)
                }
                .font(.custom(CustomFont.RobotoBold.rawValue, size: 24))
                
                // 대여기간 정보
                Text(" ")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 24))
                
                HStack {
                    Text("픽업장소")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    Spacer()
                    Text("*픽업 장소에서만 대여 확정이 가능합니다.")
                        .font(.custom(CustomFont.NSKRLight.rawValue, size: 12))
                        .foregroundColor(Color.red_EB1808)
                }
                
                // 픽업장소 정소
                Text(" ")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 24))
                
                PickUpTime()
            }
            .frame(maxHeight: .infinity)
            
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 200)
        .overlay(ReservationButton())
    }
    
    @ViewBuilder
    private func ItemPicker() -> some View {
        HStack(alignment: .center, spacing: 0) {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
            }
            .foregroundColor(Color.navy_1E2F97)
            
            Spacer()
            Text(itemInfo.name)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "chevron.right")
            }
            .foregroundColor(Color.navy_1E2F97)
        }
        .padding(.top, 10)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
        .frame(maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    private func PickUpTime() -> some View {
        
        Group {
            Text("픽업시간")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
            
            Text(getDate(date:viewModel.pickUpTime))
                .font(.custom(CustomFont.RobotoMedium.rawValue, size: 24))
            
            DatePicker("Pickup Time Picker", selection: $viewModel.pickUpTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
        }
    }
    
    @ViewBuilder
    private func ReservationButton() -> some View {
        VStack {
            Spacer()
            
            Button {
                presentationMode.wrappedValue.dismiss()
                isRentalTerminal.toggle()
            } label: {
                Capsule()
                    .foregroundColor(Color.navy_1E2F97)
                    .overlay(Text("예약하기")
                        .foregroundColor(Color.white)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20)))
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 50)
            TransparentDivider()
        }
    }
    
    func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: date)
    }
}
//
//struct RentalDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        RentalSheet(itemInfo: RentalItemInfo.dummyRentalItem(), isRentalTerminal: .constant(false))
//    }
//}
