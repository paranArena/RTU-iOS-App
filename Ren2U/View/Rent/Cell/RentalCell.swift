//
//  TempCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//
import SwiftUI
import Kingfisher

struct RentalCell: View {
    
    enum CancelOption {
        case `default`
        case none
        case yes
        case no
    }
    
    let rentalItemInfo: RentalData

    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 5) {
//                if let thumbnailPath = rentalItemInfo.imagePath {
//                    KFImage(URL(string: thumbnailPath))
//                        .onFailure { err in
//                            print(err.errorDescription ?? "KFImage Optional err")
//                        }
//                        .resizable()
//                        .frame(width: 80, height: 80)
//                        .cornerRadius(20)
//
//                }
               
                VStack(alignment: .leading) {
                    Text("Product name")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    
                    Text("Club name")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.gray_ADB5BD)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("예약취소")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.navy_1E2F97)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                }
                .background(Capsule().stroke(Color.navy_1E2F97, lineWidth: 1))

            }
            .padding(.horizontal, 10)
            Divider()
        }
    }
    
    
    
    @ViewBuilder
    private func ButtonCancelRental() -> some View {
        Button {
            
        } label: {
            Text("예약취소")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .capsuleStrokeAndForegroundColor(color: Color.navy_1E2F97)
        }
    }
    
    @ViewBuilder
    private func ButtonReturn() -> some View {
        Button {
            
        } label: {
            Text("반납하기")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .capsuleStrokeAndForegroundColor(color: Color.navy_1E2F97)
        }
    }
}

//struct RentalItemHCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RentalItemHCell(rentalItemInfo: .dummyRentalItem())
//    }
//}
