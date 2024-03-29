//
//  ItemData.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/16.
//

import Foundation
import SwiftUI

struct ItemData: Codable {
    let id, numbering: Int
    let rentalPolicyDto: String
    let rentalInfo: Rental?
    
    static func dummyItemData() -> ItemData {
        return ItemData(id: 0, numbering: 0, rentalPolicyDto: "FIFO", rentalInfo: nil)
    }
    
    
    struct Rental: Codable {
        let rentalStatus: String
        let rentDate: String
        let expDate: String?
        let meRental: Bool
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case numbering
        case rentalPolicyDto = "rentalPolicy"
        case rentalInfo
    }
//
    var bgColor: Color {
        if rentalPolicyDto == "FIFO" {
            return Color.yellow_FFB800
        } else {
            return Color.green_2CA900
        }
    }

    var rentalPolicy: String {
        if rentalPolicyDto == "FIFO" {
            return "선착순"
        } else {
            return "기간제"
        }
    }
    
    var status: String {
        if rentalInfo == nil {
            return "대여 가능"
        } else if rentalInfo!.rentalStatus == "WAIT" {
            return "예약중"
        } else if  rentalInfo!.rentalStatus == "RENT" {
            return "대여 불가"
        } else {
            return "에러"
        }
    }
    
    var mainButtonFillColor: Color {
        if rentalInfo == nil {
            return Color.navy_1E2F97
        } else if rentalInfo!.meRental {
            return Color.navy_1E2F97
        } else {
            return Color.clear
        }
    }
    
    var mainButtonFGColor: Color {
        if rentalInfo == nil {
            return Color.white
        } else if rentalInfo!.meRental {
            return Color.white
        } else {
            return Color.navy_1E2F97
        }
    }
    
    var mainButtonDisable: Bool {
        if rentalInfo == nil {
            return false
        } else if rentalInfo!.meRental {
            return false
        } else {
            return true
        }
    }
    
    var buttonText: String {
        if rentalInfo == nil {
            return "대여하기"
        } else if !rentalInfo!.meRental {
            return "대여불가"
        } else if rentalInfo!.rentalStatus == "WAIT" {
            return "대여확정"
        } else if rentalInfo!.rentalStatus == "RENT" {
            return "반납하기"
        } else {
            return "에러"
        }
    }
    
    
    
    var alertMessage: String {
        if rentalInfo == nil {
            return "아이템을 예약하시겠습니까?"
        } else if !rentalInfo!.meRental {
            return "대여불가"
        } else if rentalInfo!.rentalStatus == "WAIT" {
            return "아이템을 대여하시겠습니까?"
        } else if rentalInfo!.rentalStatus == "RENT" {
            return "아이템을 반납하시겠습니까?"
        } else {
            return "에러"
        }
    }
}
