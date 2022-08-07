//
//  Item.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/03.
//

import SwiftUI
import Kingfisher
import HidableTabView


extension Item {
    enum Selection: Int {
        case queue
        case term
    }
}

struct Item: View {
    
    let itemInfo: RentalItemInfo
    @State private var date: Date = Date.now
    @State private var isShowingRentalSelection = false
    @State private var selection: Selection?
    
    init(itemInfo: RentalItemInfo) {
        self.itemInfo = itemInfo
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                CarouselImage()
                
                Text("Ren2U")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                
                Text(itemInfo.itemName)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 26))
                
                Divider()
                
                HStack {
                    Text("카테고리")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                        .foregroundColor(Color.Gray_495057)
                    
                    Spacer()
                }
                
                HStack {
                    Text("물품가치")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                        .foregroundColor(Color.Gray_495057)
                    
                    Spacer()
                }
                
                Text("물품목록")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(Color.Gray_495057)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationTitle(" ")
        .navigationBarTitleDisplayMode(.inline)
        .hideTabBar(animated: false)
        .overlay(BottomToolbar())
        .onAppear {
            let itemAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
            itemAppearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = itemAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = itemAppearance
        }
    }
    
    @ViewBuilder
    private func CarouselImage() -> some View {
        TabView {
            KFImage(URL(string: itemInfo.imageSource)!)
                .onFailure { err in
                    print(err.errorDescription ?? "KFImage Optional err")
                }
                .resizable()
                .frame(width: SCREEN_WIDTH, height: 300)
            
            KFImage(URL(string: itemInfo.imageSource)!)
                .onFailure { err in
                    print(err.errorDescription ?? "KFImage Optional err")
                }
                .resizable()
                .frame(width: SCREEN_WIDTH, height: 300)
        }
        .frame(height: 300)
        .tabViewStyle(PageTabViewStyle())
    }
    
    @ViewBuilder
    private func BottomToolbar() -> some View {
        ZStack(alignment: .center) {
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                
                VStack {
                    Text("기간 선택")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                    HStack {
                        QueueSelectButton()
                        TermSelectButton()
                    }
                }
                .background(Color.Gray_DEE2E6)
                .frame(width: SCREEN_WIDTH)
                .cornerRadius(20)
                .offset(y: isShowingRentalSelection ? 0 : SCREEN_HEIGHT)
                .animation(.spring(), value: isShowingRentalSelection)
            }
            
            
            VStack {
                Spacer()
                HStack {
                    Text("대여가능 수량 : \(itemInfo.remain)")
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                        .frame(maxWidth: SCREEN_WIDTH)
                    RentalButton()
                }
                .background(Color.BackgroundColor)
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)
            .ignoresSafeArea(.container, edges: .bottom)
            .frame(maxWidth: SCREEN_WIDTH)
        }
    }
    
    @ViewBuilder
    private func QueueSelectButton() -> some View {
        Button  {
            if selection != .queue {
                selection = .queue
            } else {
                selection = nil
            }
            
        } label: {
            VStack(alignment: .center) {
                Text("선착순")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                
                Text("바로 대여가 가능합니다.")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            }
            .foregroundColor(selection == .queue ? Color.BackgroundColor : Color.LabelColor)
        }
        .frame(maxWidth: SCREEN_WIDTH, minHeight: 80)
        .background(selection == .queue ? Color.Navy_1E2F97 : Color.Gray_DEE2E6)
    }
    
    @ViewBuilder
    private func TermSelectButton() -> some View {
        Button {
            if selection != .term {
                selection = .term
            } else {
                selection = nil
            }
        } label: {
            VStack {
                Text("기간제")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                
                Text("일정기간 대여가 가능합니다.")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            }
            .foregroundColor(selection == .term ? Color.BackgroundColor : Color.LabelColor)
        }
        .frame(maxWidth: SCREEN_WIDTH, minHeight: 80)
        .background(selection == .term ? Color.Navy_1E2F97 : Color.Gray_DEE2E6)
    }
    
    @ViewBuilder
    private func RentalButton() -> some View {
        Button {
            isShowingRentalSelection.toggle()
        } label: {
            Capsule()
                .fill(!isShowingRentalSelection ? Color.white : Color.Navy_1E2F97)
                .overlay(Text("대여하기")
                    .foregroundColor(!isShowingRentalSelection ? Color.Navy_1E2F97 : Color.white)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20)))
                .frame(height: 40)
        }
        .frame(maxWidth: SCREEN_WIDTH)
        .overlay(Capsule().stroke(Color.Navy_1E2F97, lineWidth: 2))
    }
            
    
    @ViewBuilder
    private func DatePickerOverlay() -> some View {
        VStack {
            Spacer()
            DatePicker("데이트 피커", selection: $date)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct Item_Previews: PreviewProvider {
    static var previews: some View {
        Item(itemInfo: RentalItemInfo.dummyRentalItem())
    }
}
