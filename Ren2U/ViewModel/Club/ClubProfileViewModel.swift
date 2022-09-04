//
//  CreateGroupModel .swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//

import SwiftUI

extension ClubProfile {
    
    class ViewModel: ObservableObject {
        @Published var clubProfileData = ClubProfileData()
        @Published var mode: ClubProfile.Mode
        
        @Published var tagsText = ""
        @Published var isShowingTagPlaceholder = true
        @Published var showImagePicker = false
        @Published var selectedUIImage: UIImage?
        
        @Published var offset: CGFloat = 0
        
        init(putModeData: ClubData, mode: ClubProfile.Mode) {
            clubProfileData = ClubProfileData(clubData: putModeData)
            self.mode = mode
        }
        
        init(mode: ClubProfile.Mode){
            self.mode = mode
        }
        
        
        func showTagPlaceHolder(newValue: ClubProfile.Field?) {
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
                        self.clubProfileData.hashtags.append(parsedTag)
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
                self.clubProfileData.hashtags.append(parsedTag)
            }
            
            self.tagsText = ""
        }
        
        func printUTF8Length(tag: String) {
            print("\(tag.utf8.count)")
        }
    }

}

extension ClubProfile  {
    enum Field: Int, CaseIterable {
        case groupName
        case tagsText
        case introduction
    }
}
