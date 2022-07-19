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
    @Published var isConfirmed = true 
    @Published var certificationNum = ""
    @Published var timer = Timer()

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { Timer in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer.invalidate()
            }
        })
    }
    
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
