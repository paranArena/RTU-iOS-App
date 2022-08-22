//
//  CustomToggleStyle.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/22.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            configuration.label
            Spacer()

        
            Capsule()
                .fill(configuration.isOn ? Color.yellow : Color.gray_868E96)
                .frame(width: 70)
                .overlay(
                    Text(configuration.isOn ? "on" : "off")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 10))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: configuration.isOn ? .leading : .trailing)
                        .padding(.horizontal, 8)
                )
                .overlay(
                    HStack {
                        Circle()
                            .fill(Color.white)
                            .padding(.horizontal, 1.5)
                            .frame(width: 30, height: 30)
                    }.frame(maxWidth: .infinity, alignment: configuration.isOn ? .trailing : .leading)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
        .animation(.spring(), value: configuration.isOn)
        .frame(height: 30)
    }
}
