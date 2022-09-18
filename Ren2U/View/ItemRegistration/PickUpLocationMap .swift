//
//  PickUpLocationMap .swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/25.
//

import SwiftUI
import MapKit

struct PickUpLocationMap: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var locationManager: LocationManager
    @ObservedObject var itemVM: ItemViewModel
    @State private var isPresentedAlert = true
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: false, userTrackingMode: .constant(.none))
                .overlay(Image(systemName: "checkmark").foregroundColor(.navy_1E2F97))

            
            Button {
                itemVM.locationLongtitude = locationManager.region.center.longitude
                itemVM.locationLatitude = locationManager.region.center.latitude
                itemVM.isSelectedLocation = true
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("선택된 장소에서 픽업")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(locationManager.fgColor)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(locationManager.bgColor))
            }
            .padding(.horizontal, 20)
        }
        .basicNavigationTitle(title: "픽업장소 선택")
        .onAppear {
            locationManager.requestAuthorization()
        }
    }
}

//struct PickUpLocationMap_Previews: PreviewProvider {
//    static var previews: some View {
//        PickUpLocationMap(itemVM: ItemViewModel())
//    }
//}
