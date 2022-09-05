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
    @StateObject private var mapVM = MapViewModel()
    @ObservedObject var itemVM: ItemViewModel
    
    var body: some View {
        VStack {
            
            Map(coordinateRegion: $mapVM.region, showsUserLocation: false, userTrackingMode: .constant(.none))
                .overlay(Image(systemName: "checkmark").foregroundColor(.navy_1E2F97))
            
            Button {
                itemVM.locationLongtitude = mapVM.region.center.longitude
                itemVM.locationLatitude = mapVM.region.center.latitude
                itemVM.isSelectedLocation = true
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("선택된 장소에서 픽업")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(Color.navy_1E2F97))
            }
            .padding(.horizontal, 20)
        }
        .basicNavigationTitle(title: "픽업장소 선택")
    }
}

struct PickUpLocationMap_Previews: PreviewProvider {
    static var previews: some View {
        PickUpLocationMap(itemVM: ItemViewModel())
    }
}
