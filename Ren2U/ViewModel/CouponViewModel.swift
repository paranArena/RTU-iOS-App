//
//  CouponViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import SwiftUI
import Alamofire

class CouponViewModel: ObservableObject {
    
    @Published var alert = Alert()
    @Published var oneButtonAlert = OneButtonAlert()
    
    func createCouponAdmin() {
    }
}
