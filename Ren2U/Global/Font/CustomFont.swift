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
    case NSKRMedium = "NotoSansKR-Medium"
    case NSKRRegular = "NotoSansKR-Regular"
    case NSKRLight = "NotoSansKR-Light"
    case NSKRBlack = "NotoSansKR-Black"
    case NSKRBold = "NotoSansKR-Bold"
    
    case RobotoBlack = "Roboto-Black"
    case RobotoRegular = "Roboto-Reuglar"
    case RobotoMedium = "Roboto-Medium"
    case RobotoBold = "Roboto-Bold"
}
