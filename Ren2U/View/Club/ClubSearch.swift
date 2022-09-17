//
//  Search.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/28.
//

import SwiftUI
import CoreAudio

struct ClubSearch: View {
    
    @StateObject private var clubSearchVM = ClubSearchViewModel()
    @Binding var search: String
    @Binding var tabSelection: Int
    
    
    @State private var isActive = false
    @State private var offset: CGFloat = .zero
    @State private var searchDelay = 0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var selectedClubData = ClubAndRoleData.dummyClubAndRoleData()
    @State private var alert = Alert()
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 10) {
            Text("검색된 그룹 목록")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            
            BounceControllScrollView(baseOffset: 100, offset: $offset) {
                VStack {
                    ForEach(clubSearchVM.clubData.indices, id: \.self) { i in
                        NavigationLink {
                            ClubPage(tabSelection: $tabSelection, clubData: $clubSearchVM.clubData[i], clubActive: $isActive)
                        } label: {
                            HStack(spacing: 0) {
                                HorizontalClubCell(clubData: clubSearchVM.clubData[i])
                                OverlayFinder(index: i)
                            }
                        }
                        
                        Divider() 
                    }
                }
            }
        }
        .alert(alert.title, isPresented: $alert.isPresented) {
            Button("아니요", role: .cancel) {}
            Button("예") { Task { await alert.callback() }}
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            Task {
                if search.isEmpty {
                    await clubSearchVM.searchClubsAll()
                }
            }
        }
        .onChange(of: search) { newValue in
            self.searchDelay = 0
        }
        .onReceive(timer) { _ in
            searchDelay += 1
            if searchDelay == 10 && !search.isEmpty {
                Task {
                    clubSearchVM.searchWithText(text: search)
                }
            }
        }
        
    }
    
    @ViewBuilder
    private func OverlayFinder(index: Int) -> some View {
        
        switch clubSearchVM.clubData[index].clubRole {
        case ClubRole.admin.rawValue, ClubRole.owner.rawValue, ClubRole.user.rawValue:
            JoindeClubOverlay()
        case ClubRole.wait.rawValue:
            ApplicatedGroupOverlay()
        case ClubRole.none.rawValue:
            NoneOverlay(index: index)
        default:
            Text("Group Role Err")
        }
    }
    
    @ViewBuilder
    private func JoindeClubOverlay() -> some View {
        Text("가입된 그룹")
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
            .foregroundColor(Color.gray_868E96)
            .padding()
    }
    
    @ViewBuilder
    private func ApplicatedGroupOverlay() -> some View {
        Text("요청완료")
            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
            .foregroundColor(Color.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(Color.navy_1E2F97))
            .padding()
    }
    
    @ViewBuilder
    private func NoneOverlay(index: Int) -> some View {
        Button {
            alert.title = "그룹에 가입하시겠습니까?"
            alert.isPresented = true
            alert.callback = {
                Task {
                    let cludId = clubSearchVM.clubData[index].id
                    await clubSearchVM.requestClubJoin(clubId: cludId)
                    clubSearchVM.clubData[index].clubRole = await clubSearchVM.getMyClubRole(clubId: cludId)
                }
            }
        } label: {
            Text("가입 요청")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.navy_1E2F97)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .overlay(
                    Capsule()
                        .strokeBorder(Color.navy_1E2F97, lineWidth: 1)
                )
        }
        .padding()
    }
}


//struct Search_Previews: PreviewProvider {
//    static var previews: some View {
//        Search()
//    }
//}
