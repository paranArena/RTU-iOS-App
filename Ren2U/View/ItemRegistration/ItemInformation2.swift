//
//  ItemInformation2.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI


extension ItemInformation2 {
    enum Field: Int {
        case fifoCount
        case reserveCount
        case fifoPeriod
        case reservePeriod
        
        var type: String {
            switch self {
            case .fifoCount, .fifoPeriod:
                return "선착순"
            case .reserveCount, .reservePeriod:
                return "기간제"
            }
        }
        
        var suffix: String {
            switch self {
            case .fifoCount, .reserveCount:
                return "개"
                
            case .fifoPeriod, .reservePeriod:
                return "일"
            }
        }
    }
}
struct ItemInformation2: View {
    
    @ObservedObject var itemVM: ItemViewModel
    @Binding var isActive: Bool
    @State private var pickerSelection: Field?
    @State private var integerPicker = [[Int]] (repeating: [Int](repeating: 0, count: 2), count: 4)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                Text("다음 사항을 입력해주세요")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                    .frame(maxHeight: .infinity, alignment: .bottom)
                
                Text("수량")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    .foregroundColor(.gray_495057)
                    .isHidden(hidden: pickerSelection == .fifoPeriod || pickerSelection == .reservePeriod)
                
                //  MARK: 선착순 수량 버튼
                PickerSet(selection: Field.fifoCount)
                Divider()
                    .isHidden(hidden: pickerSelection != nil)
                
                //  MARK: 기간제 수량 버튼
                PickerSet(selection: Field.reserveCount)
            }
            
            Group {
                Text("최대 대여기간 설정")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    .foregroundColor(.gray_495057)
                    .padding(.top, pickerSelection == nil ? 40 : 0)
                    .isHidden(hidden: pickerSelection == .fifoCount || pickerSelection == .reserveCount)
                
                //  MARK: 대여기간 선착순 버튼
                PickerSet(selection: Field.fifoPeriod)
                Divider()
                    .isHidden(hidden: pickerSelection != nil)
                //  MARK: 대여기간 기간제 버튼
                PickerSet(selection: Field.reservePeriod)
            }
            
            NavigationLink {
                PickUpLocation(itemVM: itemVM, isActive: $isActive)
            } label: {
                RightArrow(isDisabled: false)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            
        }
        .animation(.easeInOut, value: self.pickerSelection)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.BackgroundColor)
        .onTapGesture {
            self.pickerSelection = nil
        }
        .basicNavigationTitle(title: "물품 등록")
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func PickerSet(selection: Field) -> some View {
        Group {
            Button {
                if pickerSelection == nil {
                    pickerSelection = selection
                } else {
                    pickerSelection = nil
                }
            } label: {
                HStack(spacing: 0) {
                    Text(selection.type)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    
                    Text("\(integerPicker[selection.rawValue][0])\(integerPicker[selection.rawValue][1])")
                        .font(.custom(CustomFont.RobotoMedium.rawValue, size: 24))
                    Text(selection.suffix)
                }
                .foregroundColor(.primary)
            }
            .isHidden(hidden: pickerSelection != nil && pickerSelection != selection)
            
            CustomPicker(values: $integerPicker[selection.rawValue])
                .customHide(selectedValue: pickerSelection?.rawValue, value: selection.rawValue)
        }
    }

}

struct ItemInformation2_Previews: PreviewProvider {
    static var previews: some View {
        ItemInformation2(itemVM: ItemViewModel(), isActive: .constant(true))
    }
}
