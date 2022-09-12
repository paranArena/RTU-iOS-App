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
    @State private var remainTime: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(data: ClubRentalData) {
        self.data = data
        remainTime = data.rentalInfo.remainTime
        remainTime = max(remainTime, 0)
    }
    
    var body: some View {
        HStack {
            
            if let imagePath = data.imagePath {
                KFImage(URL(string: imagePath)).onFailure { err in
                    print(err.errorDescription ?? "KFImage err")
                }
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(15)
            }
            
            VStack(alignment: .leading) {
                Text("\(data.name) - \(data.numbering)")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                
                Text(data.memberName)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                
                Text(data.rentalInfo.rentDate.toYMDformat())
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                    .foregroundColor(.gray_868E96)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Text("픽업까지")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                
                Text(remainTime.toRemainTime())
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
        .onReceive(timer) { time in
            remainTime -= 1
            remainTime = max(0, remainTime)
        }
    }
}

//struct RetnalNoticeCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RetnalNoticeCell()
//    }
//}
