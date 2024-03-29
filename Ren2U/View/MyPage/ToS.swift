//
//  ToS.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/10.
//

import SwiftUI

struct ToS: View {
    
    @Environment(\.isPresented) var isPresented
    
    let cautionText = "Ren2U는 사용자가 아래와 같이 잘못된 방법이나 행위로 서비스를 이용할 경우 사용에 대한 제재(이용정지, 강제탈퇴 등)를 가할 수 있습니다.\n\n1. 잘못된 방법으로 서비스의 제공을 방해하거나 Ren2U가 안내하는 방법 이외의 다른 방법을 사용하여 Ren2U 서비스에 접근하는 행위\n\n2. 다른 이용자의 정보를 무단으로 수집, 이용하거나 다른 사람들에게 제공하는 행위\n\n3.서비스 영리나 홍보 목적으로 이용하는 행위\n\n4.음란 정보나 저작권 침해 정보 등 공서양속 및 법령에 위반되는 내용의 정보 등을 발송하거나 게시하는 행위\n\n5.Ren2U의 동의 없이 Ren2U 서비스 또는 이에 포함된 소프트웨어의 일부를 복사, 수정, 배포, 판매, 양도, 대여, 담보 제공하거나 타인에게 그 이용을 허락하는 행위\n\n6.소프트웨어를 역 설계하거나 소스 코드의 추출을 시도하는 등 Ren2U 서비스를 복제, 분해 똔느 모방하거나 기타 변형하는 행위\n\n7.관련 법령, Ren2U의 모든 약관 또는 운영정책을 준수하지 않는 행위"
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Group {
                    Introduction()
                    AboutAccount()
                    Caution()
                    AboutPrivacy()
                    PostCopyRight()
                    PostManagement()
                }
                Group {
                    ServiceAndPromotionDisplay()
                    LocationService()
                    ServiceInterruption()
                    ServiceWithdrawl()
                    ToSModification()
                    UserComment()
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .basicNavigationTitle(title: "이용약관")
        .controllTabbar(isPresented)
        .avoidSafeArea()
    }
    
    
    @ViewBuilder
    private func Introduction() -> some View {
        Group {
            
            Text("안녕하세요?\nRen2U 서비스를 이용해 주셔서 감사합니다. 아주대학교 렌털 플랫폼 서비스를 제공하는 Ren2U가 아래 준비한 약관을 읽어 주시면 감사드리겠습니다.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
    
    @ViewBuilder
    private func AboutAccount() -> some View {
        Group {
            Text("계정 관련")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
            Text("Ren2U는 서비스 특성상 별다른 아이디 없이 아주대학교 이메일만으로 계정을 생성하실 수 있습니다. 다만, 실제 이메일의 소유주임을 확인하기 위해서 가입 당시 인증 절차를 거치게 됩니다.\n\n계정은 본인만 이용할 수 있고, 다른 사람에게 이용을 허락하거나 양도할 수 없습니다. 사용자는 계정과 관련된 정보를 수정할 수 있습니다.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
    
    @ViewBuilder
    private func Caution() -> some View {
        Group {
            Text("사용시 주의해야할 점")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
            Text(cautionText)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
    
    @ViewBuilder
    private func AboutPrivacy() -> some View {
        Group {
            Text("개인정보 보호 관련")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
            Text("개인정보는 Ren2U 서비스의 원활한 제공을 위하여 사용자가 동의한 목적과 범위 내에서만 이용됩니다. 개인정보 보호 관련 기타 상세한 사항은 Ren2U 개인정보처리방침을 참고하시기 바랍니다")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
    
    @ViewBuilder
    private func PostCopyRight() -> some View {
        Group {
            Text("게시물의 저작권 보호")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
            Text("1. Ren2U 서비스 사용자가 서비스 내에 게시한 게시물의 저작권은 해당 게시물의 저작자에게 귀속됩니다.\n\n2. 사용자가 서비스 내에 게시하는 게시물은 검색결과 내지 서비스 및 관련 프로모션, 광고 등에 노출될 수 있으며, 해당 노출을 위해 필요한 범위 내에서는 일부 수정, 복제, 편집되어 게시될 수 있습니다. 이 경우, Ren2U는 저작권법 규정을 준수하며, 사용자는 운영자 문의를 통해 해당 게시물에 대해 삭제, 비공개 등의 조치를 요청할 수 있습니다.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
    
    @ViewBuilder
    private func PostManagement() -> some View {
        Group {
            Text("게시물의 관리")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
            Text("1. 사용자의 게시물이 \"정보통신망법\" 및 \"저작권법\"등 관련법에 위반되는 내용을 포함하는 경우, 권리자는 관련법이 정한 절차에 따라 해당 게시물의 게시중단 및 삭제 등을 요청할 수 있으며, Ren2U은 관련법에 따라 조치를 취하여야 합니다\n\n2. Ren2U는 전항에 따른 권리자의 요청이 없는 경우라도 권리침해가 인정될 만한 사유가 있거나 기타 플랫폼 정책 및 관련법에 위반되는 경우에는 관련법에 따라 해당 게시물에 대해 임시조치(삭제, 노출제한, 게시중단) 등을 취할 수 있습니다.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
    
    @ViewBuilder
    private func ServiceAndPromotionDisplay() -> some View {
        Group {
            Text("서비스 고지 및 홍보내용 표시")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
            Text("Ren2U는 서비스 사용자분의 편의를 위해 서비스 이용과 관련된 각종 고지 및 기타 Ren2U 서비스 홍보를 포함한 다양한 정보를 Ren2U 서비스에 표시하거나 사용자의 휴대폰 문자, 알림 메시지(Push Notification) 등으로 발송할 수 있으며 서비스 사용자분은 이에 동의합니다. 이 경우 서비스 사용자분의 통신환경 또는 요금구조에 따라 서비스 사용자분이 데이터 요금 등을 부담할 수 있습니다. 한편 Ren2U는 서비스 사용자분이 수집에 동의한 서비스 내 활동 정보를 기초로 Ren2U에게 직접적인 수익이 발생하지 않거나 Ren2U이 판매하는 상품과 직접적인 관련성이 없는 한도에서 다른 서비스 사용자분 등이 판매하는 상품 또는 서비스에 관한 정보를 위와 같은 방법으로 서비스 사용자분에게 보낼 수 있으며 서비스 사용자분은 이에 동의합니다. 물론 서비스 사용자분은 관련 법령상 필요한 내용을 제외하고 언제든지 이러한 정보에 대한 수신 거절을 할 수 있으며, 이 경우 Ren2U은 즉시 위와 같은 정보를 보내는 것을 중단합니다.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
    
    @ViewBuilder
    private func LocationService() -> some View {
        Group {
            Text("위치기반서비스 관련")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
            Text("Ren2U는 사용자의 실생활에 더욱 보탬이 되는 유용한 서비스를 제공하기 위하여 Ren2U 서비스에 위치기반서비스를 포함시킬 수 있습니다. Ren2U의 위치기반서비스는 사용자의 단말기기의 위치정보를 수집하는 위치정보사업자로부터 위치정보를 전달받아 제공하는 무료 서비스이며, 구체적으로는 사용자의 현재 위치를 기준으로 대여/반납 자격을 부여합니다.\n\nRen2U은 사용자의 위치정보를 안전하게 보호하기 위하여 위치정보관리책임자(이형기kkmi356@ajou.ac.kr)를 지정하고 있습니다.\n\n만약 사용자와 Ren2U 간의 위치정보와 관련한 분쟁에 대하여 협의가 어려운 때에는 사용자은 위치정보의 보호 및 이용 등에 관한 법률 제28조 2항 및 개인정보보호법 제43조의 규정에 따라 개인정보 분쟁조정위원회에 조정을 신청할 수 있습니다.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
    
    @ViewBuilder
    private func ServiceInterruption() -> some View {
        Group {
            Text("서비스 중단")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
            Text("Ren2U 서비스는 장비의 유지∙보수를 위한 정기 또는 임시 점검 또는 다른 상당한 이유로 Ren2U 서비스의 제공이 일시 중단될 수 있으며, 이때에는 미리 서비스 제공화면에 공지하겠습니다. 만약, Ren2U로서도 예측할 수 없는 이유로 Ren2U 서비스가 중단된 때에는 Ren2U이 상황을 파악하는 즉시 통지하겠습니다.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
    
    @ViewBuilder
    private func ServiceWithdrawl() -> some View {
        Group {
            Text("이용계약 해지(서비스 탈퇴)")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
            
            Text("사용자가 Ren2U 서비스의 이용을 더 이상 원치 않는 때에는 언제든지 Ren2U 서비스 내 제공되는 탈퇴 메뉴를 이용하여 Ren2U 서비스 탈퇴 신청을 할 수 있습니다. 다만, 부정이용 방지를 위해 대여가 진행중이거나 관련 분쟁이 발생한 사용자는 서비스 탈퇴가 특정 기간 동안 제한될 수 있습니다. 이용계약이 해지되면 법령 및 개인정보처리방침에 따라 사용자 정보를 보유하는 경우를 제외하고는 사용자 정보나 사용자가 작성한 게시물 등 모든 데이터는 삭제됩니다. 다만, 사용자가 작성한 게시물이 제3자에 의하여 스크랩 또는 다른 공유 기능으로 게시되거나, 사용자가 제3자의 게시물에 댓글, 채팅 등 게시물을 추가하는 등의 경우에는 다른 이용자의 정상적 서비스 이용을 위하여 필요한 범위 내에서 Ren2U 서비스 내에 삭제되지 않고 남아 있게 됩니다.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
    
    @ViewBuilder
    private func ToSModification() -> some View {
        Group {
            Text("약관 수정")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
            Text("Ren2U은 법률이나 Ren2U 서비스의 변경사항을 반영하기 위한 목적 등으로 본 약관이나 각 Ren2U 서비스 고객센터의 Ren2U 서비스 이용방법, 해당 안내 및 고지사항을 수정할 수 있습니다. 본 약관이 변경되는 경우 Ren2U은 변경 사항을 게시하며, 변경된 약관은 게시한 날로부터 7일 후부터 효력이 발생합니다.\n\nRen2U는 변경된 약관을 게시한 날로부터 효력이 발생되는 날까지 약관변경에 대한 사용자의 의견을 기다리겠습니다. 위 기간이 지나도록 사용자의 의견이 Ren2U에 접수되지 않으면, 사용자가 변경된 약관에 따라 서비스를 이용하는 데에 동의하는 것으로 보겠습니다. 사용자가 변경된 약관에 동의하지 않는 경우 변경된 약관의 적용을 받는 해당 서비스의 제공이 더 이상 불가능하게 됩니다.")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
    
    @ViewBuilder
    private func UserComment() -> some View {
        Group {
            Text("사용자 의견")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 14))
            Text("Ren2U는 사용자의 의견을 소중하게 생각합니다. 사용자는 언제든지 서비스 내 Ren2U 운영자에게 문의 통해 의견을 개진할 수 있습니다. Ren2U은 푸시 알림, 채팅 방법, 휴대폰 번호 등으로 사용자에게 여러 가지 소식을 알려드리며, 사용자 전체에 대한 통지는 Ren2U 서비스 초기화면 또는 공지사항 란에 게시함으로써 효력이 발생합니다.\n\n본 약관은 Ren2U와 사용자와의 관계에 적용되며, 제3자의 수익권을 발생시키지 않습니다.\n\n사용자가 본 약관을 준수하지 않은 경우에, Ren2U가 즉시 조치를 취하지 않더라도 Ren2U이 가지고 있는 권리를 포기하는 것이 아니며, 본 약관 중 일부 조항의 집행이 불가능하게 되더라도 다른 조항에는 영향을 미치지 않습니다.\n\n본 약관 또는 Ren2U 서비스와 관련하여서는 대한민국의 법률이 적용됩니다.\n\n공고일자: 2022년 9월 13일\n\n시행일자: 2022년 9월 20일")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
        }
    }
}

struct ToS_Previews: PreviewProvider {
    static var previews: some View {
        ToS()
    }
}
