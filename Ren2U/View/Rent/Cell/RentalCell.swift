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
    
    @EnvironmentObject var clubVM: ClubViewModel
    let rentalItemInfo: RentalData
    @Binding var selectedClubId: Int
    @Binding var selectedItemId: Int
    @Binding var isShowingAlert: Bool
    @Binding var callback: () -> ()
    @State private var isShowingDistanceAlert = false

    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 5) {
                if let thumbnailPath = rentalItemInfo.imagePath {
                    KFImage(URL(string: thumbnailPath))
                        .onFailure { err in
                            print(err.errorDescription ?? "KFImage Optional err")
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(15)

                }
               
                VStack(alignment: .leading) {
                    Text("\(rentalItemInfo.name)  \(rentalItemInfo.numbering)")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    
                    Text(rentalItemInfo.clubName)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                        .foregroundColor(.gray_ADB5BD)
                        .lineLimit(1)
                }
                
                Spacer()
                if rentalItemInfo.rentalInfo.rentalStatus == "WAIT" {
                    Button {
                        selectedItemId = rentalItemInfo.id
                        selectedClubId = rentalItemInfo.clubId
                        isShowingAlert = true
                        callback = {
                            Task {
                                await clubVM.cancelRent(clubId: selectedClubId, itemId: selectedItemId)
                                await clubVM.getMyRentals()
                            }
                        }
                    } label: {
                        Text("예약취소")
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                            .foregroundColor(.navy_1E2F97)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                    }
                    .background(Capsule().stroke(Color.navy_1E2F97, lineWidth: 1))
                } else {
                    Button {
                        isShowingAlert = true
                        callback = {
                            Task {
                                await clubVM.returnRent(clubId: rentalItemInfo.clubId, itemId: rentalItemInfo.id)
                                await clubVM.getMyRentals()
                            }
                        }
                    } label: {
                        Text("반납하기")
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                            .foregroundColor(.navy_1E2F97)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                    }
                    .background(Capsule().stroke(Color.navy_1E2F97, lineWidth: 1))
                }
            }
            .padding(.horizontal, 10)
            Divider()
        }
        .alert("거리가 너무 멉니다", isPresented: $isShowingDistanceAlert) {
            Button("확인", role: .cancel) {}
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
