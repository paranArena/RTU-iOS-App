//
//  ItemInformation2.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI


extension ItemInformation2 {
    enum Selection: Int {
        case fifoCount
        case reserveCount
        case fifoPeriod
        case reservePeriod
    }
}
struct ItemInformation2: View {
    
    @ObservedObject var itemVM: ItemViewModel
    @Binding var isActive: Bool
    @State private var pickerSelection: Selection?
    @State private var integerPicker = [[Int]] (repeating: [Int](repeating: 0, count: 2), count: 4)
    
    let integers1 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    let integers2 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Group {
                Text("다음 사항을 입력해주세요")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                
                Text("수량")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    .foregroundColor(.gray_495057)
                    .isHidden(hidden: pickerSelection == .fifoPeriod || pickerSelection == .reservePeriod)
                
                //  MARK: 선착순 수량 버튼
                Button {
                    if pickerSelection == nil {
                        pickerSelection = .fifoCount
                    } else {
                        pickerSelection = nil
                    }
                } label: {
                    HStack(spacing: 0) {
                        Text("선착순")
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        
                        Text("\(integerPicker[0][0])\(integerPicker[0][1])")
                            .font(.custom(CustomFont.RobotoMedium.rawValue, size: 24))
                        Text("개")
                    }
                    .foregroundColor(.primary)
                }
                .isHidden(hidden: pickerSelection != nil && pickerSelection != .fifoCount)
                
                DoublePicker(rowIndex: Selection.fifoCount.rawValue)
                
                Divider()
                    .isHidden(hidden: pickerSelection != nil)
                
                
                //  MARK: 기간제 수량 버튼
                Button {
                    if pickerSelection == nil {
                        pickerSelection = .reserveCount
                    } else {
                        pickerSelection = nil
                    }
                } label: {
                    HStack(spacing: 0) {
                        Text("기간제")
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        
                        Text("\(integerPicker[1][0])\(integerPicker[1][1])")
                            .font(.custom(CustomFont.RobotoMedium.rawValue, size: 24))
                        Text("개")
                    }
                    .foregroundColor(.primary)
                }
                .isHidden(hidden: pickerSelection != nil && pickerSelection != .reserveCount)
                
                DoublePicker(rowIndex: Selection.reserveCount.rawValue)
            }
            
            Group {
                Text("최대 대여기간 설정")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    .foregroundColor(.gray_495057)
                    .padding(.top, 40)
                    .isHidden(hidden: pickerSelection == .fifoCount || pickerSelection == .reserveCount)
                
                //  MARK: 대여기간 선착순 버튼
                Button {
                    if pickerSelection == nil {
                        pickerSelection = .fifoPeriod
                    } else {
                        pickerSelection = nil
                    }
                } label: {
                    HStack(spacing: 0) {
                        Text("선착순")
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        
                        Text("\(integerPicker[2][0])\(integerPicker[2][1])")
                            .font(.custom(CustomFont.RobotoMedium.rawValue, size: 24))
                        Text("개")
                    }
                    .foregroundColor(.primary)
                }
                .isHidden(hidden: pickerSelection != nil && pickerSelection != .fifoPeriod)
                
                DoublePicker(rowIndex: Selection.fifoPeriod.rawValue)
                
                Divider()
                    .isHidden(hidden: pickerSelection != nil)
                
                //  MARK: 대여기간 기간제 버튼
                Button {
                    if pickerSelection == nil {
                        pickerSelection = .reservePeriod
                    } else {
                        pickerSelection = nil
                    }
                } label: {
                    HStack(spacing: 0) {
                        Text("기간제")
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                        
                        Text("\(integerPicker[3][0])\(integerPicker[3][1])")
                            .font(.custom(CustomFont.RobotoMedium.rawValue, size: 24))
                        Text("개")
                    }
                    .foregroundColor(.primary)
                }
                .isHidden(hidden: pickerSelection != nil && pickerSelection != .reservePeriod)
                
                DoublePicker(rowIndex: Selection.reservePeriod.rawValue)
            }
            
            
            NavigationLink {
                PickUpLocation(itemVM: itemVM, isActive: $isActive)
            } label: {
                RightArrow(isDisabled: false)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .basicNavigationTitle(title: "물품 등록")
        .onTapGesture {
            self.pickerSelection = nil
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func DoublePicker(rowIndex: Int) -> some View {
        HStack(alignment: .center) {
            Picker("Picker", selection: $integerPicker[rowIndex][0]) {
                ForEach(integers1, id: \.self) { i in
                    Text("\(i)")
                }
            }
            .frame(maxWidth: SCREEN_WIDTH / 4)
            .clipped()
            
            
            Picker("Picker", selection: $integerPicker[rowIndex][1]) {
                ForEach(integers2, id: \.self) { i in
                    Text("\(i)")
                }
            }
            .frame(maxWidth: SCREEN_WIDTH / 4)
            .clipped()
        }
        .pickerStyle(.wheel)
        .isHidden(hidden: pickerSelection == nil || pickerSelection?.rawValue != rowIndex)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct ItemInformation2_Previews: PreviewProvider {
    static var previews: some View {
        ItemInformation2(itemVM: ItemViewModel(), isActive: .constant(true))
    }
}
