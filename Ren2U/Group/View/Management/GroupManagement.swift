//
//  GroupManagement.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI
import Introspect

extension GroupManagement {
    enum ManageSelection: Int, CaseIterable {
        case profileEdit
        case rentalManagement
        case notice
        case memberManagement
        case rentalActive
        
        var title: String {
            switch self {
            case .profileEdit:
                return "프로필 수정"
            case .rentalManagement:
                return "대여/물품 관리"
            case .notice:
                return "공지사항"
            case .memberManagement:
                return "멤버 관리"
            case .rentalActive:
                return "대여목록 활성화"
            }
        }
    }
}

extension GroupManagement {
    enum RentalSelection: Int, CaseIterable {
        case reservation
        case rental
        case `return`
        
        var title: String {
            switch self {
            case .reservation:
                return "예약"
            case .rental:
                return "대여"
            case .return:
                return "반납"
            }
        }
    }
}

struct GroupManagement: View {
    
    @State private var rentalSelection: RentalSelection = .reservation
    @State private var rentalWidth: CGFloat = 0
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 80) {
                ManagingNavigation()
                
                VStack(alignment: .center, spacing: 10) {
                    Text("알림")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    
                    ScrollView {
                        VStack {
                            SignUpCell(userInfo: User.dummyUser())
                            ReturnNoticeCell(userInfo: User.dummyUser(), rentalItemInfo: ReturnInfo.dummyReturnInfo())
                            SignUpCell(userInfo: User.dummyUser())
                            SignUpCell(userInfo: User.dummyUser())
                            SignUpCell(userInfo: User.dummyUser())
                        }
                        .padding(.leading, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                    }
                    .frame(height: 400)
                }
                .background(Color.grayF1F2F3)
                .cornerRadius(15)
                
                VStack(alignment: .center, spacing: 0) {
                    Text("대여현황")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                        .padding(.bottom, 20)
                    
                    HStack(spacing: 0) {
                        ForEach(RentalSelection.allCases, id: \.rawValue) { selection in
                            Button {
                                self.rentalSelection = selection
                            } label: {
                                Text(selection.title)
                                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                                    .foregroundColor(rentalSelection == selection ? Color.Navy_1E2F97 : Color.gray868E96)
                            }
                            .frame(maxWidth: .infinity)
                            .background(GeometryReader {
                                // detect Pull-to-refresh
                                Color.clear.preference(key: ViewWidthKey.self, value: $0.frame(in: .global).width)
                            })
                            .onPreferenceChange(ViewWidthKey.self) {
                                rentalWidth = $0
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Rectangle()
                            .fill(Color.Navy_1E2F97)
                            .frame(width: rentalWidth * 0.6, height: 2)
                            .padding(.leading, rentalWidth * CGFloat(rentalSelection.rawValue) + rentalWidth * 0.2)
                            .animation(.spring(), value: rentalSelection)
                        Spacer()
                    }
                    
                    
                    VStack {
                        Text("임시 텍스트 ")
                    }
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.BackgroundColor)
                }
                .background(Color.Gray_DEE2E6)
                .cornerRadius(15)
            }
            .padding(.horizontal, 10)
        }
        .navigationTitle("그룹 관리자")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func ManagingNavigation() -> some View {
        VStack(alignment: .center, spacing: 0) {
            ForEach(ManageSelection.allCases, id : \.rawValue) { selection in
                HStack {
                    Text(selection.title)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                    Spacer()
                }
                Divider()
                    .padding(.horizontal, 10)
            }
        }
        .background(Color.Gray_DEE2E6)
        .cornerRadius(15)
    }
}

struct GroupManagement_Previews: PreviewProvider {
    static var previews: some View {
        GroupManagement()
    }
}

public struct ViewWidthKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
