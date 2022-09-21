//
//  RentalDetailViewModel .swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/17.
//

import SwiftUI

//  RentalDetail과 RentalDatePicker에서 모두 이용
class DateViewModel: ObservableObject {
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @Published var pickUpTime = Date.now
    
    
    //  RentalDatePicker에서 이용
    @Published var currentDate = Date.now
    @Published var rentalDays = [DateValue]()
    
    init(startDate: Binding<Date?>, endDate: Binding<Date?>) {
        self._startDate = startDate
        self._endDate = endDate
    }
    
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월"
        return formatter.string(from: self.currentDate)
    }
    
    var startDateString: String {
        guard let startDate = startDate else { return " " }
        return rentalDate(date: startDate)
    }
    
    var endDateString: String {
        guard let endDate = endDate else { return " " }
        return " ~ \(rentalDate(date: endDate))"
    }
    
    private func rentalDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    func selectRentalDays(index: Int) {
        
        if self.startDate == nil {
            self.startDate = self.rentalDays[index].date
        } else if self.endDate == nil {
            if self.rentalDays[index].date < self.startDate! {
                self.endDate = self.startDate
                self.startDate = self.rentalDays[index].date
            } else {
                self.endDate = self.rentalDays[index].date
            }
        } else {
            self.startDate = self.rentalDays[index].date
            self.endDate = nil
        }
        
        self.colorPeriod()
    }
    
    private func colorPeriod() {
        let startIndex = self.rentalDays.firstIndex { date in
            date.date == self.startDate
        } ?? 0
        
        var endIndex: Int
        if self.endDate == nil {
            endIndex = startIndex
        } else {
            endIndex = self.rentalDays.firstIndex { date in
                date.date == self.endDate
            } ?? self.rentalDays.count - 1
        }
        
        for i in 0..<self.rentalDays.count {
            if i >= startIndex && i <= endIndex {
                self.rentalDays[i].isClicked = true
            } else {
                self.rentalDays[i].isClicked = false
            }
        }
    }
    
    func setUpDayString(index: Int) -> String {
        guard rentalDays[index].day != -1 else { return " " }
        return "\(rentalDays[index].day)"
                
    }
    
    func setUpTextColor(index: Int) -> Color {
        
        let baseDate = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
        
        if rentalDays[index].date == self.startDate || rentalDays[index].date == self.endDate {
            return Color.BackgroundColor
        } else if rentalDays[index].date < baseDate {
            return Color.gray
        }
        
        return Color.LabelColor
    }
    
    func setUpDayBackground(index: Int) -> Color {
        if rentalDays[index].day == -1 {
            return Color.BackgroundColor
        } else if rentalDays[index].date == self.startDate || rentalDays[index].date == self.endDate {
            return Color.navy_1E2F97
        } else if rentalDays[index].isClicked {
            return Color.navy_1E2F97.opacity(0.15)
        }
        
        return Color.BackgroundColor
    }
    
    func setDaysOfMonth() {
        
        let calendar = Calendar.current
        
        var dats = self.currentDate.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: dats.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            dats.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        self.rentalDays = dats
        
        guard let startDate = self.startDate else {  return  }
        
        guard let endDate = self.endDate else {  return   }


        for i in 0..<self.rentalDays.count {
            if self.rentalDays[i].date >= startDate && self.rentalDays[i].date <= endDate {
                self.rentalDays[i].isClicked = true
            }
        }
    }
}
