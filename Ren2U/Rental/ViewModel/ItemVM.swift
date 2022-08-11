//
//  ItemVM.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/10.
//

import SwiftUI


extension Item {
    enum Selection: Int {
        case queue
        case term
    }
}

extension Item {
    
    class ViewModel: ObservableObject {
        @Published var date: Date = Date.now
        @Published var isShowingRentalSelection = false
        @Published var isShowingRental = false
        @Published var selection: Selection?
        @Published var isRentalTerminal = false
        @Published var isRented: Bool = false
        
        @Published var imageSelection = 0
        @Published var timer = Timer()
        
        init() {
            runTimer()
        }
        
        func initValues() {
            self.selection = nil
            self.isShowingRentalSelection = false
        }
        
        func runTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { Timer in
                self.imageSelection = (self.imageSelection + 1) % 3
            })
        }
    }
}
