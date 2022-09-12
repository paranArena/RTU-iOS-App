//
//  ProductMap.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/13.
//

import SwiftUI
import MapKit
import CoreLocation

struct ItemMap: View {
    
    let itemInfo: RentalData
    
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.isPresented) var isPresented
    @EnvironmentObject var clubVM: ClubViewModel
    @StateObject var itemVM = ItemMapViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var remainTime = 10
    @State private var min = ""
    @State private var sec = ""
    @State private var region: MKCoordinateRegion
    
    let span =  MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    init(itemInfo: RentalData) {
        self.itemInfo = itemInfo
        let itemLocation = CLLocationCoordinate2D(latitude: itemInfo.location.latitude, longitude: itemInfo.location.longitude)
        self._region = State<MKCoordinateRegion>(initialValue: MKCoordinateRegion(center: itemLocation, span: span))
        remainTime = itemInfo.rentalInfo.time
    }
    
    var body: some View {
        let itemLocation = CLLocationCoordinate2D(latitude: itemInfo.location.latitude, longitude: itemInfo.location.longitude)
        let anotaions: [Annotation] = [Annotation(coordinate: itemLocation)]
        
        VStack {
            
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.none), annotationItems: anotaions) { annotation  in
                MapAnnotation(coordinate: annotation.coordinate) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.navy_1E2F97)
                }
            }
            
            HStack {
                Text("\(min) \(sec)")
                    .font(.custom(CustomFont.NSKRBold.rawValue, size: 15))
                    .foregroundColor(.red_EB1808)
                
                Text(itemInfo.location.name)
                    .font(.custom(CustomFont.NSKRBold.rawValue, size: 15))
                
                RentButton()
                    .font(.custom(CustomFont.NSKRBold.rawValue, size: 15))
            }
            .padding(.horizontal)
            .isHidden(hidden: itemInfo.rentalInfo.rentalStatus != RentalStatus.wait.rawValue)
            
            Group {
                ReturnButton()
            }
            .isHidden(hidden: itemInfo.rentalInfo.rentalStatus != RentalStatus.rent.rawValue)
        }
        .basicNavigationTitle(title: itemInfo.name)
        .controllTabbar(isPresented)
        .alert("", isPresented: $itemVM.alert.isPresented) {
            Button("취소", role: .cancel) {}
            Button("확인") { itemVM.alert.callback() }
        } message: {
            Text(itemVM.alert.title)
        }
        .avoidSafeArea()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                remainTime = Int(60*10 - Date.now.timeIntervalSince(itemInfo.rentalInfo.toDate))
                remainTime = max(0, remainTime)
                
                min = "\(Int(remainTime / 60))분"
                sec = "\(remainTime % 60)초"
                
                if remainTime == 0 {
                    timer.invalidate()
                }
            }
        }
    }
    
    @ViewBuilder
    private func ReturnButton() -> some View {
        let itemLocation = CLLocationCoordinate2D(latitude: itemInfo.location.latitude, longitude: itemInfo.location.longitude)
        Button {
            if locationManager.requestAuthorization() {
                if locationManager.region.center.distance(from: itemLocation) > 30 {
                    locationManager.isPresentedDistanceAlert = true
                } else {
                    itemVM.alert.callback = {
                        Task {
                            await itemVM.returnRent(clubId: itemInfo.clubId, itemId: itemInfo.id)
                            await clubVM.getMyRentals()
                            dismiss()
                        }
                    }
                    itemVM.alert.title = "아이템을 반납하시겠습니까?"
                    itemVM.alert.isPresented = true
                }
            }
        } label: {
            NavyCapsule(text: "반납하기")
        }

    }
    
    @ViewBuilder
    private func RentButton() -> some View {
        let itemLocation = CLLocationCoordinate2D(latitude: itemInfo.location.latitude, longitude: itemInfo.location.longitude)
        
        Button {
            if itemInfo.rentalInfo.rentalStatus == RentalStatus.wait.rawValue {
                if locationManager.requestAuthorization() {
                    if locationManager.region.center.distance(from: itemLocation) > 30 {
                        locationManager.isPresentedDistanceAlert = true
                    } else {
                        itemVM.alert.callback = {
                            Task {
                                await itemVM.applyRent(clubId: itemInfo.clubId, itemId: itemInfo.id)
                                await clubVM.getMyRentals()
                                dismiss()
                            }
                        }
                        itemVM.alert.title = "아이템을 대여하시겠습니까?"
                        itemVM.alert.isPresented = true
                    }
                }
            } 
        } label: {
            NavyCapsule(text: "대여확정")
        }
    }
}

//struct ProductMap_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductMap()
//    }
//}
