//
//  RentalComplete.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/10.
//

import SwiftUI
import HidableTabView
import MapKit
import CoreLocation

struct ItemLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let tintColor: Color
    
    static func dummyItemLocation() -> ItemLocation {
        return ItemLocation(name: "우산", coordinate: CLLocationCoordinate2D(latitude: 37.279952, longitude: 127.046147), tintColor: .red)
    }
}

extension RentalComplete {
    
    enum MapDetails {
        static let startingLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    }
    
    class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
        @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation,
                                                   span: MapDetails.defaultSpan)
        
        var locationManager: CLLocationManager?
    
        
        override init() {
            super.init()
        }
    }

}

struct RentalComplete: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var mapViewModel = MapViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.279952, longitude: 127.046147), span: MapDetails.defaultSpan)
    let itemInfo: RentalItemInfo
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("예약이 완료되었습니다!")
                .font(.custom(CustomFont.NSKRBlack.rawValue, size: 24))
            
            Text("물품이름 : \(itemInfo.itemName)")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
            
            Text("대여기간 : ")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                .padding(.bottom, 30)
            
            Map(coordinateRegion: $region, interactionModes: [], showsUserLocation: false, userTrackingMode: .constant(.none), annotationItems: [ItemLocation.dummyItemLocation()]) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    Image(systemName: "mappin.circle")
                        .foregroundColor(Color.navy_1E2F97)
                }
            }
            .frame(width: 300, height: 200)
            .padding(.bottom, 30)
            
            HStack(alignment: .center, spacing: 0) {
                Text("10분 내")
                    .font(.custom(CustomFont.RobotoBold.rawValue, size: 22))
                    .foregroundColor(Color.navy_1E2F97)
                Text("에")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text("성호관 201호")
                    .font(.custom(CustomFont.RobotoBold.rawValue, size: 22))
                    .foregroundColor(Color.navy_1E2F97)
                Text("에서 물품을 픽업해주세요!")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
            }
            .padding(.bottom, 40)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("확인")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
                    .foregroundColor(Color.navy_1E2F97)
            }
            .padding(.horizontal, 80)
            .padding(.vertical, 12)
            .overlay(
                Capsule()
                    .strokeBorder(Color.navy_1E2F97, lineWidth: 3)
            )
        }
        .navigationBarHidden(true)
    }
}

struct RentalComplete_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
