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
    let itemLocation: CLLocationCoordinate2D
    
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var clubVM: ClubViewModel
    @StateObject var rentVM = RentViewModel(rentService: RentService(url: ServerURL.runningServer.url),
                                              clubProductService: ClubProductService(url: ServerURL.runningServer.url))
    @Environment(\.dismiss) var dismiss
    @Environment(\.isPresented) var isPresented
    
    @State private var remainTime = 10
    @State private var min = ""
    @State private var sec = ""
    @State private var region: MKCoordinateRegion
    
    init(itemInfo: RentalData) {
        self.itemInfo = itemInfo
        self.itemLocation = CLLocationCoordinate2D(latitude: itemInfo.location.latitude ?? 0, longitude: itemInfo.location.longitude ?? 0)
        self._region = State<MKCoordinateRegion>(initialValue: MKCoordinateRegion(center: itemLocation, span: DEFAULT_SPAN))
        remainTime = itemInfo.rentalInfo.time
    }
    
    var body: some View {
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
        .avoidSafeArea()
        .alert(rentVM.twoButtonsAlert.title, isPresented: $rentVM.twoButtonsAlert.isPresented) {
            Button("취소", role: .cancel) {}
            Button("확인") { Task {
                await rentVM.twoButtonsAlert.callback()
                await clubVM.getMyRentals()
            }}
        } message: { rentVM.twoButtonsAlert.message }
        .alert(rentVM.oneButtonAlert.title, isPresented: $rentVM.oneButtonAlert.isPresented) {
            Button("확인") {
                Task { clubVM.getMyRentals }
                dismiss() }
        } message: {
            rentVM.oneButtonAlert.message
        }
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
        let itemLocation = CLLocationCoordinate2D(latitude: itemInfo.location.latitude ?? 0, longitude: itemInfo.location.longitude ?? 0)
        Button {
            if locationManager.checkDistance(productRegion: itemLocation) {
                rentVM.rentButtonTapped(rentalData: itemInfo)
            }
        } label: {
            NavyCapsule(text: "반납하기")
        }

    }
    
    @ViewBuilder
    private func RentButton() -> some View {
        let itemLocation = CLLocationCoordinate2D(latitude: itemInfo.location.latitude ?? 0, longitude: itemInfo.location.longitude ?? 0)
        
        Button {
            if locationManager.checkDistance(productRegion: itemLocation) {
                rentVM.rentButtonTapped(rentalData: itemInfo)
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
