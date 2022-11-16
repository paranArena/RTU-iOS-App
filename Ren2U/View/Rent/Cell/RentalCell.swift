//
//  TempCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/07.
//
import SwiftUI
import Kingfisher
import CoreLocation

struct RentalCell: View {
    
    enum CancelOption {
        case `default`
        case none
        case yes
        case no
    }
    
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var clubVM: ClubViewModel
    let rentalItemInfo: RentalData
    @Binding var alert: Alert
    @Binding var singleButtonAlert: Alert

    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 5) {
                
                PreviewImage(imagePath: rentalItemInfo.imagePath)
               
                VStack(alignment: .leading) {
                    Text("\(rentalItemInfo.name)  \(rentalItemInfo.numbering)")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    
                    HStack {
                        Text(rentalItemInfo.clubName)
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                            .foregroundColor(.gray_ADB5BD)
                            .lineLimit(1)
                        
                        if let expDate = rentalItemInfo.rentalInfo.expDate {
                            Text("반납일 : \(expDate.toDate().toYMDformat())")
                                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                                .foregroundColor(.gray_ADB5BD)
                                .lineLimit(1)
                        }
                    }
                }
                
                Spacer()
                if rentalItemInfo.rentalInfo.rentalStatus == "WAIT" {
                    Button {
                        let selectedItemId = rentalItemInfo.id
                        let selectedClubId = rentalItemInfo.clubId
                        
                        alert.isPresented = true
                        alert.message = Text(rentalItemInfo.rentalInfo.alertMeesage)
                        alert.callback = {
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
                        if let latitude = rentalItemInfo.location.latitude, let longitude = rentalItemInfo.location.longitude {
                            if locationManager.isAuthorized {
                                let coreLocatino = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                
                                if locationManager.region.center.distance(from: coreLocatino) > 50 {
                                    locationManager.isPresentedDistanceAlert = true
                                } else {
                                    showReturnRental()
                                }
                            } else {
                                locationManager.isPresentedAlert = true
                            }
                        } else {
                            showReturnRental()
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
            .frame(minHeight: 80)
            .padding(.horizontal, 10)
            Divider()
        }
    }
    
    private func showReturnRental() {
        alert.isPresented = true
        alert.message = Text(rentalItemInfo.rentalInfo.alertMeesage)
        alert.callback = {
            Task {
                await clubVM.returnRent(clubId: rentalItemInfo.clubId, itemId: rentalItemInfo.id)
                await clubVM.getMyRentals()
            }
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
