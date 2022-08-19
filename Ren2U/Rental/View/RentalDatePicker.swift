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
    @State private var width: CGFloat = .zero

    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            MonthHeader()
                .padding(.bottom, 20)
            
            let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
            
            HStack(alignment: .center, spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .background(GeometryReader {
                            Color.clear.preference(key: ViewWidthKey.self, value: $0.frame(in: .global).width)
                        })
                        .onPreferenceChange(ViewWidthKey.self) {
                            width = $0
                        }
                }
            }
            .padding(.bottom, 5)
            
            let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(viewModel.rentalDays.indices, id: \.self) { index in
                    let day = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
                    Button {
                        viewModel.selectRentalDays(index: index)
                    } label: {
                        Text(viewModel.setUpDayString(index: index))
                            .foregroundColor(viewModel.setUpTextColor(index: index))
                    }
                    .frame(width: width, height:  width)
                    .background(viewModel.setUpDayBackground(index: index))
                    .overlay(
                        Rectangle()
                            .stroke(Color.Gray_DEE2E6, lineWidth: 1)
                    )
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
            .foregroundColor(Color.Navy_1E2F97)

            
            Text(viewModel.month)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 18))
                .padding(.horizontal, 20)
            
            Button {
                viewModel.currentDate = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.currentDate)!
            } label: {
                Image(systemName: "chevron.right")
            }
            .foregroundColor(Color.Navy_1E2F97)

        }
        .onChange(of: viewModel.currentDate) { _ in
            viewModel.setDaysOfMonth()
        }
    }
}

struct Calendar_Previews: PreviewProvider {
    static var previews: some View {
        RentalDatePicker(viewModel: RentalDetail.ViewModel())
    }
}

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
