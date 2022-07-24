//
//  CreateGroupModel .swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import SwiftUI

enum CreateGroupField: Int, CaseIterable {
    case groupName
    case tagsText
    case introduction 
}
class CreateGroupModel: ObservableObject {
    
    @Published var groupName = ""
    @Published var tagsText = ""
    @Published var introduction = "" 
    @Published var tags = [Tag]()
    
    
    func printUTF8Length(tag: String) {
        print("\(tag.utf8.count)")
    }
}
