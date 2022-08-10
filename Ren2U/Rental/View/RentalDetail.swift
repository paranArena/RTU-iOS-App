//
//  RentalDetail.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/10.
//

import SwiftUI

struct RentalDetail: View {
    
    let itemInfo: RentalItemInfo
    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var pickUpTime = Date.now
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
                Text("대여기간 확인")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                
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
                
                Text(getDate(date:pickUpTime))
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 24))
                
            }
            .frame(maxHeight: .infinity)
            
            DatePicker("Pickup Time Picker", selection: $pickUpTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            
            Button {
                self.isRentalTerminal.toggle()
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("종료")
            }


        }
    }
    
    func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        let result = dateFormatter.string(from: date)
        return result
    }
}

struct RentalDetail_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
