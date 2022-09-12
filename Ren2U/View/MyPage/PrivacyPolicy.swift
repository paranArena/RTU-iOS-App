//
//  PrivacyPolicy.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/12.
//

import SwiftUI

struct PrivacyPolicy: View {
    
    
    
    enum Guide: Int, CaseIterable {
        case privacyPolicy
        case informationCollected
        case purposeOfInformation
        case provisionOfPrivacy
        case storageAndDestruction
        case right
        case cookie
        case service
        case etc
        
        var title: String {
            switch self {
            case .privacyPolicy:
                return "1. 개인정보 처리방침"
            case .informationCollected:
                return "2. 수집하는 개인정보의 항목"
            case .purposeOfInformation:
                return "3. 수집한 개인정보의 처리 목적"
            case .provisionOfPrivacy:
                return "4. 개인정보의 제3자 제공"
            case .storageAndDestruction:
                return "5. 수집한 개인정보의 보관 및 파기"
            case .right:
                return "6. 정보주체의 권리, 의무 및 행사"
            case .cookie:
                return "7. 쿠키"
            case .service:
                return "8. 개인정보에 관한 책임자 및 서비스"
            case .etc:
                return "9. 기타"
            }
        }
        
        var message: String {
            switch self {
            case .privacyPolicy:
                return "개인정보 처리방침은 Ren2U가 특정한 가입절차를 거친 이용자들만 이용 가능한 폐쇄형 서비스를 제공함에 있어, 개인정보를 어떻게 수집·이용·보관·파기하는지에 대한 정보를 담은 방침을 의미합니다. 개인정보 처리방침은 개인정보보호법 등 국내 개인정보 보호 법령을 모두 준수하고 있습니다."
            case .informationCollected:
                return "Ren2U는 서비스 제공을 위해 다음 항목 중 최소한의 개인정보를 수집합니다.\n\n1) 회원가입 시 수집되는 개인정보\n\n학교 이메일, 이름, 학과, 학번, 휴대폰 번호\n\n2) 별도로 수집되는 개인정보\n\n프로필 사진, 그룹명, 대표자·담당자 정보"
            case .purposeOfInformation:
                return "수집된 개인정보는 다음의 목적에 한해 이용됩니다.\n\n1. 가입 및 탈퇴 의사 확인, 회원 식별\n\n2. 서비스 제공 및 기존·신규 시스템 개발·유지·개선\n\n3. 불법·약관 위반 게시물 게시 등 부정행위 방지를 위한 운영 시스템 개발·유지·개선\n\n4. 문의·제휴·광고·이벤트·게시 관련 요청 응대 및 처리"
            case .provisionOfPrivacy:
                return "Ren2U는 회원의 개인정보를 제3자에게 제공하지 않습니다. 단, 다음의 사유가 있을 경우 제공할 수 있습니다.\n\n1. 이용자의 생명이나 안전에 급박한 위험이 확인되어 이를 해소하기 위한 경우\n\n2. 관련법에 따른 규정에 의한 경우\n\n3. 관리자의 경우(가입자 식별을 위해)"
            case .storageAndDestruction:
                return "Ren2U는 서비스를 제공하는 동안 개인정보 처리방침 및 관련법에 의거하여 회원의 개인정보를 지속적으로 관리 및 보관합니다. 탈퇴 등 개인정보 수집 및 이용목적이 달성될 경우, 수집된 개인정보는 즉시 또는 다음과 같이 일정 기간 이후 파기됩니다.\n\n1. 가입시 수집된 개인정보: 탈퇴 후 30일\n\n2. 기기 정보 및 로그 기록: 최대 1년\n\n3. 게시 요청 관리자 정보: 최대 2년"
            case .right:
                return "회원은 언제든지 서비스 내부 ‘마이페이지’에서 자신의 개인정보를 조회하거나 수정, 삭제, 탈퇴를 할 수 있습니다."
            case .cookie:
                return "쿠키란 웹사이트를 운영하는 데 이용되는 서버가 귀하의 브라우저에 보내는 아주 작은 텍스트 파일로서 귀하의 컴퓨터 및 모바일 기기에 저장됩니다. 서비스는 사이트 로그인을 위해 아이디 식별에 쿠키를 사용할 수 있습니다."
            case .service:
                return "Ren2U는 회원의 개인정보를 최선으로 보호하고 관련된 불만을 처리하기 위해 노력하고 있습니다.\n\n관련 문의사항은 (이형기kkmi356@ajou.ac.kr) 통해 전달해주시기 바랍니다."
            case .etc:
                return "이 개인정보 처리방침은 2022년 9월 13일에 개정되었습니다."
            }
        }
    }
    
    
    @Environment(\.isPresented) var isPresented
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                ForEach(Guide.allCases, id: \.rawValue) { guide in
                    Title(guide: guide)
                    Message(guide: guide)
                }
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity)
        }
        .basicNavigationTitle(title: "개인정보처리방침")
        .controllTabbar(isPresented)
        .avoidSafeArea()
    }
    
    @ViewBuilder
    private func Title(guide: Guide) -> some View {
        Text(guide.title)
            .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
    }
    
    @ViewBuilder
    private func Message(guide: Guide) -> some View {
        Text(guide.message)
            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
    }
    
}

struct PrivacyPolicy_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicy()
    }
}
