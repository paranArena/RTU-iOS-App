//
//  ClubProfileParam.swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/31.
//

import Foundation
import SwiftUI 

struct ClubProfileParam {
    var name: String = ""
    var introduction: String = ""
    var thumbnail: UIImage = UIImage(imageLiteralResourceName: "DefaultGroupImage")
    var hashtagText: String = "" 
    var hashtags: [String] = [String]()
    
    var isCreatable: Bool {
        if !name.isEmpty && !introduction.isEmpty {
            return true
        }
        return false 
    }
}
