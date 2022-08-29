//
//  CreateGroupModel .swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import SwiftUI

extension CreateGroup {
    
    class ViewModel: ObservableObject {
        
        @Published var groupName = ""
        @Published var tagsText = ""
        @Published var introduction = ""
        
        @Published var isShowingTagPlaceholder = true
        @Published var tags = [TagInfo]()
        
        @Published var showImagePicker = false
        @Published var selectedUIImage: UIImage?
        
        @Published var offset: CGFloat = 0
        
        
        func showTagPlaceHolder(newValue: CreateGroup.Field?) {
            if newValue == .tagsText {
                self.isShowingTagPlaceholder = false
            } else {
                guard self.tagsText.isEmpty else { return }
                isShowingTagPlaceholder = true
            }
        }
        
        func parsingTag() {
            
            var isPasingStarted = false
            var parsedTag = ""
            
            for c in tagsText {
                
                switch c {
                case "#" :
                    if isPasingStarted {
                        parsedTag.append("#")
                    } else {
                        isPasingStarted = true
                    }
                    break
                case " " :
                    isPasingStarted = false
                    if !parsedTag.isEmpty {
                        self.tags.append(TagInfo(tag: "#\(parsedTag)"))
                    }
                    parsedTag = ""
                    break
                default :
                    if isPasingStarted {
                        parsedTag.append(c)
                    }
                }
            }
            
            if !parsedTag.isEmpty {
                self.tags.append(TagInfo(tag: "#\(parsedTag)"))
            }
            
            self.tagsText = ""
        }
        
        func printUTF8Length(tag: String) {
            print("\(tag.utf8.count)")
        }
    }

}

extension CreateGroup  {
    enum Field: Int, CaseIterable {
        case groupName
        case tagsText
        case introduction
    }
}