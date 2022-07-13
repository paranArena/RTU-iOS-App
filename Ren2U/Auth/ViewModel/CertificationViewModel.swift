//
//  CertificationViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI

class CertificationViewModel: ObservableObject {
    
    private let certificationNumLengthLimit = 4
    @Published var isReachedLengthLimit = false
    @Published var timeRemaining = 5*60
    @Published var isWrongInput = false
    @Published var certificationNum = "" {
        didSet {
            if certificationNum.count > self.certificationNumLengthLimit {
                certificationNum = String(certificationNum.prefix(self.certificationNumLengthLimit))
                self.isReachedLengthLimit = true
            } else {
                self.isReachedLengthLimit = false
            }
        }
    }
    
    
    
    func timeString(time: Int) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
