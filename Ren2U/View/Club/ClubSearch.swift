//
//  Search.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/28.
//

import SwiftUI
import CoreAudio

struct ClubSearch: View {
    
    @EnvironmentObject var clubVM: ClubViewModel
    @Binding var search: String
    @Binding var tabSelection: Int
    
    @State private var clubData = [ClubAndRoleData]()
    @State private var isActive = false
    @State private var offset: CGFloat = .zero
    @State private var searchDelay = 0
    @State private var groupInfoIndex: Int?
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    //  Alert
    @State private var isShowingAlert = false
    @State private var selectedCLubId = 0
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 10) {
            Text("검색된 그룹 목록")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                .padding(.horizontal, 20)
            
            BounceControllScrollView(baseOffset: 100, offset: $offset) {
                VStack {
                    ForEach(clubData.indices, id: \.self) { i in
                        Button {
                            groupInfoIndex = i
                            isActive = true
                        } label: {
                            HorizontalClubCell(info: clubData[i])
                                .overlay(alignment: .trailing) {
                                    OverlayFinder(index: i)
                                }
                        }
                    }
                }
            }
        }
        .alert("", isPresented: $isShowingAlert, actions: {
            Button("아니오", role: .cancel) {}
            Button {
                Task {
                    await clubVM.requestClubJoin(clubId: selectedCLubId)
                }
            } label: {
                Text("예")
            }

        }, message: {
            Text("그룹에 가입하시겠습니까?")
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            NavigationLink(isActive: $isActive) {
                if let index = groupInfoIndex {
                    ClubPage(tabSelection: $tabSelection, clubData: $clubData[index])
                }
            } label: { }
        }
        .onAppear {
            Task {
                if search.isEmpty {
                    clubData = await clubVM.searchClubsAll()
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
                    clubData = await clubVM.searchClubsWithHashTag(hashTag: search)
                    if let groupSearchedByName = await clubVM.searchClubsWithName(groupName: search) {
                        clubData.append(groupSearchedByName)
                    }
                }
            }
        }
        
    }
    
    @ViewBuilder
    private func OverlayFinder(index: Int) -> some View {
        
        switch clubData[index].clubRole {
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
        HStack {
            Spacer()
            Text("요청완료")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 12))
                .foregroundColor(Color.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.navy_1E2F97))
        }
        .padding()
    }
    
    @ViewBuilder
    private func NoneOverlay(index: Int) -> some View {
        Button {
            selectedCLubId = clubData[index].id
            isShowingAlert = true
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
