//
//  CreateGroupModel .swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import SwiftUI

class CreateGroupModel: ObservableObject {
    
    @Published var groupName = ""
    @Published var tagsText = ""
    @Published var isShowingTagPlaceholder = true 
    @Published var introduction = ""
    @Published var tags = [TagInfo]()
    
    func showTagPlaceHolder(newValue: CreateGroupField?) {
        if newValue == .tagsText {
            self.isShowingTagPlaceholder = false
        } else {
            guard self.tagsText.isEmpty else { return }
            isShowingTagPlaceholder = true
        }
    }
    
    func parsingTag() {
        let parsedTags: [String] = tagsText.components(separatedBy: "#")
                
        for parsedTag in parsedTags {
            var parsedTag = parsedTag
            
            if parsedTag == "" || parsedTag == " " {
                continue
            } else if parsedTag.last == " " {
                parsedTag.removeLast()
            }
            
            self.tags.append(TagInfo(tag: "#\(parsedTag)"))
        }
        
        self.tagsText = ""
    }
    
    func printUTF8Length(tag: String) {
        print("\(tag.utf8.count)")
    }
}
