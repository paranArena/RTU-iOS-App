//
//  GroupPageExtension.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/30.
//

import Foundation

extension GroupPage {
    enum Role: Int, CaseIterable {
        case chairman
        case member
        case application
        case none
    }
}
