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
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var remainTime: Int
    @State private var min = ""
    @State private var sec = ""
    
    init(data: ClubRentalData) {
        self.data = data
        remainTime = data.rentalInfo.remainTime
        remainTime = max(0, remainTime)
        print("\(data.rentalInfo.remainTime)")
    }
    
    var body: some View {
        HStack {
            
            PreviewImage(imagePath: data.imagePath)
            
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
                
                Text("\(min) \(sec)")
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
        .onReceive(timer) { _ in
            print(remainTime)
            remainTime -= 1
            remainTime = max(0, remainTime)
            min = "\(remainTime / 60)분"
            sec = "\(remainTime % 60)초"

            if remainTime == 0 {
                timer.upstream.connect().cancel()
            }
        }
    }
}

//struct RetnalNoticeCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RetnalNoticeCell()
//    }
//}
