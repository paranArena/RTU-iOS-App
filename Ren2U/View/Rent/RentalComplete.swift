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


struct RentalComplete: View {
    
    @Environment(\.presentationMode) var presentationMode
    let itemInfo: ProductDetailData
    let itemNumber: Int
    let span =  MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("예약이 완료되었습니다!")
                .font(.custom(CustomFont.NSKRBlack.rawValue, size: 24))
            
            Text("물품이름 : \(itemInfo.name) - \(itemNumber)")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
//
//            Text("대여기간 : \(itemInfo. )")
//                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
//                .padding(.bottom, 30)
            let itemLocation = CLLocationCoordinate2D(latitude: itemInfo.location.latitude, longitude: itemInfo.location.longitude)
            let region = MKCoordinateRegion(center: itemLocation, span: span)
            let anonotaions: [Annotation] = [Annotation(coordinate: itemLocation)]
            
            Map(coordinateRegion: .constant(region), showsUserLocation: true, annotationItems: anonotaions) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.navy_1E2F97)
                }
            }
            
            .frame(maxWidth: 400, maxHeight: 400)
            .padding(.bottom, 30)
            
            HStack(alignment: .center, spacing: 0) {
                Text("10분 내")
                    .font(.custom(CustomFont.RobotoBold.rawValue, size: 22))
                    .foregroundColor(Color.navy_1E2F97)
                Text("에")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text("\(itemInfo.location.name)")
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
                    .padding(.horizontal, 80)
                    .padding(.vertical, 12)
                    .capsuleStrokeAndForegroundColor(color: Color.navy_1E2F97)
            }
            .padding(.bottom, 5)
        }
        .navigationBarHidden(true)
        .onAppear {
            UITabBar.hideTabBar()
        }
        .avoidSafeArea()
    }
}

struct RentalComplete_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
