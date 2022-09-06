//
//  CertificationViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI
import Alamofire

extension Certification {
    class ViewModel: ObservableObject {
        
        let certificationNumLengthLimit = 6
        
        @Published var startTime: Date
        @Published var timeRemaining: Double = 5*60
        @Published var isConfirmed: Bool = true
        @Published var certificationNum = ""
        @Published var timer = Timer()
        @Published var isSingUpSeccussActive: Bool = false
        
        init() {
            startTime = Date.now
        }
        
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
            self.startTime = Date.now
        }
        
        func endEditingIfLengthLimitReached() {
            if self.certificationNum.count == self.certificationNumLengthLimit { UIApplication.shared.endEditing() }
        }
        
        func isReachedMaxLength(num: String) -> Bool {
            guard num.count == certificationNumLengthLimit else { return false }
            return true
        }
        
        func getTimeString(time: Double) -> String {
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            return String(format: "%02i:%02i", minutes, seconds)
        }
        
        func setTimeRemaining() {
            let curTime = Date.now
            let diffTime = curTime.distance(to: startTime)
            let result = Double(diffTime.formatted())!
            timeRemaining = 5*60 + result
            
            if timeRemaining < 0 {
                timeRemaining = 0
            }
        }
        
        
    }
}

