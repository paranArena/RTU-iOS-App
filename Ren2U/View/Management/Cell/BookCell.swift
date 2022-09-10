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
                
                Text(data.rentalInfo.rentDate.toDate().toYMDformat())
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    .foregroundColor(.gray_868E96)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Text("픽업까지")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                
                Text("\(data.rentalInfo.rentDate.toDate().getTemp())")
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
            }
            .isHidden(hidden: data.rentalInfo.rentalStatus != RentalStatus.wait.rawValue)
            
            VStack {
                Text("반납예정")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                
                Text(data.rentalInfo.expDate?.toDate().toReturnString() ?? "에러")
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 14))
            }
            .isHidden(hidden: data.rentalInfo.rentalStatus != RentalStatus.rent.rawValue)

        }
        .frame(maxWidth: .infinity)
    }
}

//struct RetnalNoticeCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RetnalNoticeCell()
//    }
//}
