//
//  RentalDetail.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/10.
//

import SwiftUI

struct RentalDetail: View {
    
    let itemInfo: RentalItemInfo
    @StateObject var viewModel = ViewModel()
    @Binding var isRentalTerminal: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                Text(itemInfo.itemName)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            VStack(alignment: .leading, spacing: 10) {
                
                RentalDatePicker(viewModel: viewModel)
                
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
                        .foregroundColor(Color.Red_EB1808)
                }
                
                // 픽업장소 정소
                Text(" ")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 24))
                
                Text("픽업시간")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                
                Text(getDate(date:viewModel.pickUpTime))
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 24))
                
            }
            .frame(maxHeight: .infinity)
            
            DatePicker("Pickup Time Picker", selection: $viewModel.pickUpTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
        }
        .padding(.bottom, 200)
        .ignoresSafeArea(.all, edges: .bottom)
        .overlay(ReservationButton())
    }
    
    @ViewBuilder
    private func ReservationButton() -> some View {
        VStack {
            Spacer()
            Text("예약하기")
                .frame(width: 340, height: 50)
                .background(Color.Navy_1E2F97)
                .foregroundColor(Color.white)
                .overlay(Capsule().stroke(Color.Navy_1E2F97, lineWidth: 1))
            TransparentDivider()
        }
    }
    
    func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: date)
    }
}

struct RentalDetail_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
