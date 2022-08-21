//
//  Item.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/03.
//

import SwiftUI
import Kingfisher
import HidableTabView
import Introspect

struct Item: View {
    
    let itemInfo: RentalItemInfo
    @StateObject private var viewModel = ViewModel()
    @Environment(\.isPresented) var isPresented
    
    init(itemInfo: RentalItemInfo) {
        self.itemInfo = itemInfo
    }
    
    var body: some View {
        BounceControllScrollView(offset: $viewModel.offset) {
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
                
                Text("사용 시 주의사항")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                    .foregroundColor(Color.Gray_495057)
                
                NavigationLink("", isActive: $viewModel.isRentalTerminal) {
                    RentalComplete(itemInfo: itemInfo)
                }
            }
        }
        .overlay(BottomToolbar())
        .onAppear {
            let navigationBarAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        .controllTabbar(isPresented)
        .ignoresSafeArea(.container, edges: .top)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isShowingRental) {
            RentalSheet(itemInfo: itemInfo, isRentalTerminal: $viewModel.isRentalTerminal)
        }
    }
    
    @ViewBuilder
    private func CarouselImage() -> some View {
        TabView(selection: $viewModel.imageSelection) {
            ForEach(0..<5, id:\.self) { i in
                KFImage(URL(string: itemInfo.imageSource)!)
                    .onFailure { err in
                        print(err.errorDescription ?? "KFImage Optional err")
                    }
                    .resizable()
                    .frame(width: SCREEN_WIDTH, height: 300)
                    .tag(i)

            }
        }
        .animation(viewModel.imageSelection == 0 ? nil : .spring(), value: viewModel.imageSelection)
        .frame(height: 300)
        .tabViewStyle(PageTabViewStyle())
    }
    
    @ViewBuilder
    private func BottomToolbar() -> some View {
        VStack (alignment: .center) {
            
            Spacer()
            
            VStack(alignment: .center, spacing: 20) {
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
            .offset(y: viewModel.selection != .default ? 0 : SCREEN_HEIGHT)
            .animation(.spring(), value: viewModel.selection)
            
            HStack {
                Text("대여가능 수량 : \(itemInfo.remain)")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                    .frame(maxWidth: SCREEN_WIDTH)
                RentalButton()
            }
            .background(Color.BackgroundColor)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .frame(maxWidth: SCREEN_WIDTH)
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    @ViewBuilder
    private func QueueSelectButton() -> some View {
        Button  {
            if viewModel.selection != .queue {
                viewModel.selection = .queue
            } else {
                viewModel.selection = .none
            }
            
        } label: {
            VStack(alignment: .center) {
                Text("선착순")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                
                Text("바로 대여가 가능합니다.")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            }
            .foregroundColor(viewModel.selection == .queue ? Color.BackgroundColor : Color.LabelColor)
        }
        .frame(maxWidth: SCREEN_WIDTH, minHeight: 80)
        .background(viewModel.selection == .queue ? Color.Navy_1E2F97 : Color.Gray_DEE2E6)
    }
    
    @ViewBuilder
    private func TermSelectButton() -> some View {
        Button {
            if viewModel.selection != .term {
                viewModel.selection = .term
            } else {
                viewModel.selection = .none
            }
        } label: {
            VStack {
                Text("기간제")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                
                Text("일정기간 대여가 가능합니다.")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
            }
            .foregroundColor(viewModel.selection == .term ? Color.BackgroundColor : Color.LabelColor)
        }
        .frame(maxWidth: SCREEN_WIDTH, minHeight: 80)
        .background(viewModel.selection == .term ? Color.Navy_1E2F97 : Color.Gray_DEE2E6)
    }
    
    @ViewBuilder
    private func RentalButton() -> some View {
        Button {
            if viewModel.selection == .none {
                viewModel.selection = .default
            } else if viewModel.selection == .default {
                viewModel.selection = .none
            } else if viewModel.selection == .term {
                viewModel.isShowingRental = true
                viewModel.selection = .default
            } else {
                viewModel.isRentalTerminal = true
                viewModel.selection = .default
            }
        } label: {
            Capsule()
                .fill(viewModel.selection.rentalButtonFillColor)
                .overlay(Text("대여하기")
                    .foregroundColor(viewModel.selection.rentalButtonFGColor)
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
            DatePicker("데이트 피커", selection: $viewModel.date)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct Item_Previews: PreviewProvider {
    static var previews: some View {
        Item(itemInfo: RentalItemInfo.dummyRentalItem())
    }
}
