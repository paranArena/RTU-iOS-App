//
//  ContentView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

struct ContentView: View {
    
    
    @EnvironmentObject var myPageVM: MyPageViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        Group {
            Ren2UTab().isHidden(hidden: !myPageVM.isLogined)
            Login().isHidden(hidden: myPageVM.isLogined)
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
        .alert("더 가까이 이동해주세요", isPresented: $locationManager.isPresentedDistanceAlert) {
            Button("확인", role: .cancel) {} 
        }
        .alert("위치 권한", isPresented: $locationManager.isPresentedAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("위치서비스를 사용할 수 없습니다.\n기기의 '설정 > Ren2U > 위치'에서 위치 서비스를 켜주세요.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
