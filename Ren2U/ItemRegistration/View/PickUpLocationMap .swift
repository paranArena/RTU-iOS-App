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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.279952, longitude: 127.046147), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    @ObservedObject var itemVM: ItemViewModel
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.none))
                .overlay(Image(systemName: "checkmark").foregroundColor(.navy_1E2F97))
            
            Button {
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
