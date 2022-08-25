//
//  ItemViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI

class ItemViewModel: ObservableObject {
    
    @Published var image = [UIImage]()
    @Published var showPicker = false
    
    @Published var itemName = ""
    @Published var category: Category?
    @Published var itemValue = ""
    @Published var isDonation = false
    @Published var count = 0
    @Published var locationDetail = ""
    @Published var isSelectedLocation = false
    @Published var caution = ""
    @Published var isActive = false
    
    var isImageSelected: Bool {
        guard image.isEmpty else { return true }
        return false
    }
    
    var categoryString: String {
        guard let category = self.category else { return "선택"}
        return category.rawValue
    }
    
    var isAllItemInformationFilled: Bool {
        guard !itemName.isEmpty else { return false }
        guard category != nil else { return false }
        guard (isDonation || !itemValue.isEmpty) else { return false }
        return true
    }
    
    var isCountZero: Bool {
        guard count <= 0 else { return false }
        return true
    }
    
    var isItemCautionAbleToGo: Bool {
        guard isSelectedLocation else { return false }
        guard !locationDetail.isEmpty else { return false}
        return true 
    }
    
    func showImagePicker() {
        self.showPicker = true
    }
    
    func downCount() {
        count -= 1
    }
    func upCount() {
        count += 1
    }
}
