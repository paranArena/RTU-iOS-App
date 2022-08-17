//
//  Calendar.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/17.
//

import SwiftUI


struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
    var isClicked: Bool = false
}

struct RentalDatePicker: View {
    
    @ObservedObject var viewModel: RentalDetail.ViewModel
    let daySize = (SCREEN_WIDTH - 40) / 7

    
    var body: some View {
        VStack {
            MonthHeader()
            
            let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
            
            HStack {
                ForEach(days, id: \.self) { day in
                    
                    Text(day)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.fixed(daySize)), count: 7)
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(viewModel.rentalDays.indices, id: \.self) { index in
                    let day = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
                    
                    Button {
                        viewModel.selectRentalDays(index: index)
                    } label: {
                        Text(viewModel.setUpDayString(index: index))
                            .foregroundColor(viewModel.setUpTextColor(index: index))
                            .frame(maxWidth: .infinity)
                            .background(viewModel.setUpDayBackground(index: index))
                            .frame(height: daySize)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.Gray_495057, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 0)
                    .disabled(viewModel.rentalDays[index].date < day)
                }
            }
            .onAppear {
                viewModel.setDaysOfMonth()
            }
        }
    }
    
    @ViewBuilder
    private func MonthHeader() -> some View {
        HStack {
            Button {
                viewModel.currentDate = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.currentDate)!
            } label: {
                Image(systemName: "chevron.left")
            }

            
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.month)
            }
            
            Button {
                viewModel.currentDate = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.currentDate)!
            } label: {
                Image(systemName: "chevron.right")
            }

        }
        .onChange(of: viewModel.currentDate) { _ in
            viewModel.setDaysOfMonth()
        }
    }
}

//struct Calendar_Previews: PreviewProvider {
//    static var previews: some View {
//        RentalDatePicker()
//    }
//}

extension Date {
    
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
        
    }
}
