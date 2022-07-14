//
//  CertificationViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI

class CertificationViewModel: ObservableObject {
    
    let certificationNumLengthLimit = 4
    
    @Published var isReachedLengthLimit = false
    @Published var timeRemaining = 5*60
    @Published var isWrongInput = false
    @Published var certificationNum = ""
    
    func changeColor(num: String) -> Bool {
        guard num.count == certificationNumLengthLimit else { return false }
        return true
    }
    
    func timeString(time: Int) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
