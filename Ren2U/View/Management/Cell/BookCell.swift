//
//  RetnalNoticeCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI
import Kingfisher

struct BookCell: View {

    let data: ClubRentalData

    var body: some View {
        HStack {
            KFImage(URL(string: data.imagePath)!).onFailure { err in
                print(err.errorDescription ?? "KFImage err")
            }
            .resizable()
            .scaledToFill()
            .frame(width: 80, height: 80)
            .cornerRadius(15)
            
            VStack(alignment: .leading) {
                Text("\(data.name) - \(data.numbering)")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                
                Text(data.memberName)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                
                Text(data.rentalInfo.rentDate)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    .foregroundColor(.gray_868E96)
            }
            
            VStack {
                Text("픽업까지")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
            }

        }
        .frame(maxWidth: .infinity)
    }
}

//struct RetnalNoticeCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RetnalNoticeCell()
//    }
//}
