//
//  GroupTabVm.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/08.
//

import SwiftUI

extension ClubTab {
    
    class ViewModel: ObservableObject {
        @Published var groupSelection: Selection = .group
        @Published var searchText = ""
        @Published var isSearchBarFocused = false
    }
}

extension ClubTab {
    enum Selection: Int, CaseIterable {
        case group
        case notice
        
        var title: String {
            switch self {
            case .group:
                return "그룹"
            case .notice:
                return "공지사항"
            }
        }
    }
}

