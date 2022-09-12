//
//  MapViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/05.
//

import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let message = "위치서비스를 사용할 수 없습니다.\n기기의 '설정 > Ren2U > 위치'에서 위치 서비스를 켜주세요."
    
    var locationManager: CLLocationManager?
    @Published var isPresentedDistanceAlert = false
    @Published var isPresentedAlert = false
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.279952, longitude: 127.046147), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var isAuthorized: Bool {
        if authorisationStatus == .authorizedWhenInUse || authorisationStatus == .authorizedAlways {
            return true
        } else {
            return false
        }
    }
    
    var bgColor: Color {
        if isAuthorized {
            return Color.navy_1E2F97
        } else {
            return Color.gray_DEE2E6
        }
    }
    
    var fgColor: Color {
        if isAuthorized {
            return Color.white
        } else {
            return Color.black
        }
    }
    
    
    override init() {
        super.init()
        checkIfLocationServicesIsEnabled()
    }
    
    func requestAuthorization() -> Bool {
        if isAuthorized {
            region = MKCoordinateRegion(center: (locationManager?.location!.coordinate)!,
                                        span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
            return true
        } else {
            isPresentedAlert = true
            return false
        }
    }
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
            checkLocationAuthorization()
            print("checkIfLocationServicesIsEnabled: Enabled!")
        } else {
            print ("[MapViewModel] Show an alert ")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                authorisationStatus = .notDetermined
            case .restricted:
                authorisationStatus = .restricted
            case .denied:
                authorisationStatus = .denied
            case .authorizedAlways, .authorizedWhenInUse:
                authorisationStatus = .authorizedWhenInUse
                region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
