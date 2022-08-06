//
//  Item.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/03.
//

import SwiftUI
import Kingfisher
import HidableTabView

struct Item: View {
    
    let itemInfo: RentalItemInfo
    
    init(itemInfo: RentalItemInfo) {
        self.itemInfo = itemInfo
    }
    
    var body: some View {
        ScrollView {
            KFImage(URL(string: itemInfo.imageSource)!)
                .onFailure { err in
                    print(err.errorDescription ?? "KFImage Optional err")
                }
                .resizable()
                .frame(width: SCREEN_WIDTH, height: 300)
        }
        .onAppear {
            let itemAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
            itemAppearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = itemAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = itemAppearance
        }
        .hideTabBar(animated: false)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Item_Previews: PreviewProvider {
    static var previews: some View {
        Item(itemInfo: RentalItemInfo.dummyRentalItem())
    }
}
