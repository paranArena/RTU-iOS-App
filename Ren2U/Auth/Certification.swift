//
//  Certification.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/13.
//

import SwiftUI

struct Certification: View {
    var body: some View {
        VStack {
            Text("이메일로\n인증번호가 발송되었습니다.")
                .font(.system(size: 20, weight: .medium))
        }
    }
}

struct Certification_Previews: PreviewProvider {
    static var previews: some View {
        Certification()
    }
}
