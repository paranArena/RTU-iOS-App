//
//  ToS.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/10.
//

import SwiftUI

struct ToS: View {
    
    let cautionText = "Ren2U는 사용자가 아래와 같이 잘못된 방법이나 행위로 서비스를 이용할 경우 사용에 대한 제재(이용정지, 강제탈퇴 등)를 가할 수 있습니다.\n1. 잘못된 방법으로 서비스의 제공을 방해하거나 Ren2U가 안내하는 방법 이외의 다른 방법을 사용하여 Ren2U 서비스에 접근하는 행위\n2. 다른 이용자의 정보를 무단으로 수집, 이용하거나 다른 사람들에게 제공하는 행위\n3.서비스 영리나 홍보 목적으로 이용하는 행위\n4.음란 정보나 저작권 침해 정보 등 공서양속 및 법령에 위반되는 내용의 정보 등을 발송하거나 게시하는 행위\n5.Ren2U의 동의 없이 Ren2U 서비스 또는 이에 포함된 소프트웨어의 일부를 복사, 수정, 배포, 판매, 양도, 대여, 담보 제공하거나 타인에게 그 이용을 허락하는 행위\n6.소프트웨어를 역 설계하거나 소스 코드의 추출을 시도하는 등 Ren2U 서비스를 복제, 분해 똔느 모방하거나 기타 변형하는 행위\n7.관련 법령, Ren2U의 모든 약관 또는 운영정책을 준수하지 않는 행위"
    var body: some View {
        VStack {
            
            Caution()
        }
        .basicNavigationTitle(title: "")
    }
    
    @ViewBuilder
    private func Caution() -> some View {
        NavigationLink("사용시 주의해야할 점") {
            Text(cautionText)
        }
    }
}

struct ToS_Previews: PreviewProvider {
    static var previews: some View {
        ToS()
    }
}
