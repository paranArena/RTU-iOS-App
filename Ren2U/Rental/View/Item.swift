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
//        .overlay(BottomToolbar())
        .overlay(OverlayContent())
        .overlay(Modal())
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
    private func Modal() -> some View {
        VStack(alignment: .center, spacing: 0) {
            Text("위치가 확인되지 않습니다.")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 16))
            
            Text("픽업 장소에 도착한 후 다시 확정해주세요.")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .padding(.bottom, 20)
            
            Text("픽업장소 : 성호관 201호")
                .font(.custom(CustomFont.NSKRBold.rawValue, size: 16))
                .foregroundColor(Color.navy_1E2F97)
        }
        .frame(width: 320, height: 160)
        .background(Color.gray_F8F9FA)
        .cornerRadius(15)
        .clipped()
        .shadow(color: Color.gray_ADB5BD, radius: 5, x: 0, y: 0)
        .overlay(
            VStack {
                HStack {
                    Spacer()
                    Button {
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color.black)
                    }
                    .padding(.all, 10)
                }
                Spacer()
            }
        )
    }
    
    @ViewBuilder
    private func OverlayContent() -> some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            ReservationOverlayButton()
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    @ViewBuilder
    private func ReservationOverlayButton() -> some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .center, spacing: 20) {
                Text("기간 선택")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
                    .padding(.top, 20 )
                
                HStack(alignment: .center, spacing: 0) {
                    QueueSelectButton()
                    TermSelectButton()
                }
            }
            .background(Color.gray_F8F9FA)
            .frame(maxWidth: .infinity)
            .offset(y: viewModel.selection != .default ? 0 : SCREEN_HEIGHT)
            .cornerRadius(30, corners: [.topRight, .topLeft])
            .clipped()
            .shadow(color: Color.Gray_495057, radius: 10, x: 0, y: 10)
            .animation(.default, value: viewModel.selection)
            
            HStack {
                Text("대여가능 수량 : \(itemInfo.remain)")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
                    .frame(maxWidth: SCREEN_WIDTH)
                
                RentalButton()
            }
            .padding(.bottom, 30)
            .padding(.top, 10)
            .padding(.trailing, 20)
            .frame(maxWidth: .infinity)
            .background(Color.BackgroundColor)
            .clipped()
            .shadow(color: Color.Gray_495057, radius: 10, x: 0, y: 10)
        }
    }
    
    @ViewBuilder
    private func RentalCompleteOverlayButton() -> some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .center, spacing: 5) {
                Text("픽업일정")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                
                Text(viewModel.formatPickUpDate(Date.now))
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 22))
            }
            
            Button {
                
            } label: {
                Text("대여 확정")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
                    .foregroundColor(Color.white)
                    .background(Capsule().fill(Color.navy_1E2F97))
            }
        }
        .padding([.horizontal, .bottom], 20)
        .padding(.top, 10)
        .background(Color.BackgroundColor)
        .frame(maxWidth: .infinity)
        .clipped()
        .shadow(color: Color.Gray_495057, radius: 10, x: 0, y: 10)
    }
    
    @ViewBuilder
    private func ReturnOverlayButton() -> some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .center, spacing: 5) {
                Text("반납 예정일")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                
                Text(viewModel.formatReturnDate(Date.now))
                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 22))
            }
            
            Button {
                
            } label: {
                Text("반납하기")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
                    .foregroundColor(Color.white)
                    .background(Capsule().fill(Color.navy_1E2F97))
            }
        }
        .padding([.horizontal, .bottom], 20)
        .padding(.top, 10)
        .background(Color.BackgroundColor)
        .frame(maxWidth: .infinity)
        .clipped()
        .shadow(color: Color.Gray_495057, radius: 10, x: 0, y: 10)
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
        .frame(maxWidth: SCREEN_WIDTH, minHeight: 120)
        .background(viewModel.selection == .queue ? Color.navy_1E2F97 : Color.gray_F8F9FA)
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
        .frame(maxWidth: SCREEN_WIDTH, minHeight: 120)
        .background(viewModel.selection == .term ? Color.navy_1E2F97 : Color.gray_F8F9FA)
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
        .overlay(Capsule().stroke(Color.navy_1E2F97, lineWidth: 2))
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
