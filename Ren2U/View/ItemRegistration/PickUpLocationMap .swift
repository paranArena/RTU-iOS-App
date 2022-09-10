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
    @StateObject private var mapVM = LocationManager()
    @ObservedObject var itemVM: ItemViewModel
    @State private var isPresentedAlert = true
    
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
                    .foregroundColor(mapVM.fgColor)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(mapVM.bgColor))
            }
            .padding(.horizontal, 20)
            .disabled(!mapVM.isAuthorized)
        }
//        .isHidden(hidden: mapVM.isPresentedAlert)
        .alert("위치 서비스 사용", isPresented: $mapVM.isPresentedAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(mapVM.message)
        }
        .basicNavigationTitle(title: "픽업장소 선택")
        .onAppear {
            mapVM.isPresentedAlert = !mapVM.isAuthorized
        }
    }
}

//struct PickUpLocationMap_Previews: PreviewProvider {
//    static var previews: some View {
//        PickUpLocationMap(itemVM: ItemViewModel())
//    }
//}
