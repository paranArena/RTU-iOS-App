//
//  TabViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/05.
//

import SwiftUI

// Tab 사이에서의 데이터를 공유하기 위한 뷰모델 
class AmongTabsViewModel: ObservableObject {
    @Published var isItemFiltered = false
    @Published var selectedClubId: Int?
}
