//
//  CertificationViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI
import Alamofire

class CertificationModel: ObservableObject {
    
    let certificationNumLengthLimit = 4
    
    @Published var timeRemaining = 5*60
    @Published var isConfirmed = false
    @Published var certificationNum = ""
    
    func resetTimer() {
        self.timeRemaining = 5*60
    }
    
    func endEditingIfLengthLimitReached() {
        if self.certificationNum.count == self.certificationNumLengthLimit { UIApplication.shared.endEditing() }
    }
    
    func isReachedMaxLength(num: String) -> Bool {
        guard num.count == certificationNumLengthLimit else { return false }
        return true
    }
    
    func getTimeString(time: Int) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}

// MARK : MARK TEST
