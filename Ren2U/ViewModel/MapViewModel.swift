//
//  MapViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/05.
//

import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.279952, longitude: 127.046147),
                                               span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        checkIfLocationServicesIsEnabled()
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
            case .restricted:
                print("[MapViewModel] location manager restricted")
            case .denied:
                print("[MapViewModel] location manager denied")
            case .authorizedAlways, .authorizedWhenInUse:
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
