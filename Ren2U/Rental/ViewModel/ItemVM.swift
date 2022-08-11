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
        @Published var time = 0
        
        @Published var offset: CGFloat = 0 
        
        init() {
            runTimer()
        }
        
        func initValues() {
            self.selection = nil
            self.isShowingRentalSelection = false
        }
        
        func runTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { Timer in
                self.time += 1
                
                if self.time == 3 {
                    self.imageSelection = (self.imageSelection + 1) % 5
                    self.time = 0
                }
            })
        }
    }
}
