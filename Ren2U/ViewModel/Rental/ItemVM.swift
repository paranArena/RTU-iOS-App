//
//  ItemVM.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/10.
//

import SwiftUI


extension ProductDetailView {
    enum Selection: Int {
        case `default`
        case none
        case queue
        case term
        case completeFail
        
        var rentalButtonFillColor: Color {
            switch self {
            case .none, .`default`:
                return Color.white
            case .term, .queue:
                return Color.navy_1E2F97
            case .completeFail:
                return Color.clear
            }
        }
        
        var rentalButtonFGColor: Color {
            switch self {
            case .none, .`default`:
                return Color.navy_1E2F97
            case .term, .queue:
                return Color.white
            case .completeFail:
                return Color.clear
            }
        }
    }
}

extension ProductDetailView {
    class ViewModel: ObservableObject {
        @Published var date: Date = Date.now
        @Published var selection: Selection = .default
        @Published var isRentalTerminal = false
        @Published var isRented: Bool = false
        @Published var isShowingRental = false
        
        @Published var imageSelection = 0
        @Published var timer = Timer()
        @Published var time = 0
        
        @Published var offset: CGFloat = 0
        
        
        init() {
            runTimer()
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
        
        func formatPickUpDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd/HH:mm"
            return dateFormatter.string(from: date)
        }
        
        func formatReturnDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY.MM.dd"
            return dateFormatter.string(from: date)
        }
    }
}
