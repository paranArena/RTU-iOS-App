//
//  RentalItemCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/25.
//

import SwiftUI

struct RentalItemCell: View {
    
    let rental
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            KFImage(URL(string: imageSource)).onFailure { err in
                    print(err.errorDescription)
                }
                .resizable()
                .cornerRadius(15)
                .frame(width: 80, height: 80)
        }
    }
}

struct RentalItemCell_Previews: PreviewProvider {
    static var previews: some View {
        RentalItemCell()
    }
}
