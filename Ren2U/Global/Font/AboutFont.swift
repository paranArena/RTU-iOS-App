//
//  FotName .swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/23.
//

import SwiftUI

class FontName {
    
    static func printPontNames() {
        
        for family in UIFont.familyNames {
            print(family)
            
            for sub in UIFont.fontNames(forFamilyName: family) {
                print ("=====> \(sub)")
            }
        }
    }
}

enum CustomFont: String {
    case NotoSansKR = "NotoSansKR-Medium"
}
