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

struct ProductDetailView: View {
    
    let clubId: Int
    let productId: Int
    
    @EnvironmentObject var clubVM: ClubViewModel
    @StateObject private var rentVM: RentalViewModel
    @StateObject private var viewModel = ViewModel()
    @EnvironmentObject private var locationManager: LocationManager
    
    @Environment(\.isPresented) var isPresented
    @State private var rentalButtonHeight: CGFloat = .zero
    @State private var isShowingModel = false
    @State private var selectedItemId: Int?
    @State private var selctedItem: ProductDetailData.Item?
    @State private var callback: () -> () = { print("callback") }
    
    //alert
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    
    init(clubId: Int, productId: Int) {
        self.clubId = clubId
        self.productId = productId
        _rentVM = StateObject(wrappedValue: RentalViewModel(clubId: clubId, productId: productId))
        _clubVM = EnvironmentObject()
    }
    
    

    
    var body: some View {
        BounceControllScrollView(baseOffset: -10, offset: $viewModel.offset) {
            VStack(alignment: .leading, spacing: 10) {
//                CarouselImage()
                
                KFImage(URL(string: rentVM.productDetail.imagePath ?? ""))
                    .onFailure { err in
                        print(err.errorDescription ?? "KFImage Optional err")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: SCREEN_WIDTH, height: 300)
                    .clipped()
                
                Group {
                    
                    Text("REN2U")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    
                    Text("\(locationManager.region.center.distance(from: rentVM.productLocation))")

                    Text(rentVM.productDetail.name)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 26))

                    Divider()

                    HStack {
                        Text("카테고리")
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                            .foregroundColor(Color.gray_495057)

                        Spacer()

                        Text(rentVM.productDetail.category)
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    }

                    HStack {
                        Text("물품가치")
                            .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                            .foregroundColor(Color.gray_495057)
                        
                        Spacer()
                        
                        Text("\(rentVM.productDetail.price)")
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    }
                }
                .padding(.horizontal, 10)
                    
                    
                ItemList()
                    
                Caution()
                    .padding(.horizontal, 10)

                NavigationLink("", isActive: $viewModel.isRentalTerminal) {
                    RentalComplete(itemInfo: rentVM.productDetail)
                }
            }
        }
        .padding(.bottom, rentalButtonHeight)
        .isHidden(hidden: rentVM.isLoading)
        .overlay(alignment: .bottom) {
            RentalButton()
        }
        .avoidSafeArea()
        .controllTabbar(isPresented)
        .navigationTitle(rentVM.productDetail.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("", isPresented: $isShowingAlert) {
            Button("취소", role: .cancel) {}
            Button {
                callback()
                isShowingAlert = false
            } label: {
                Text("확인")
            }
        } message: {
            Text("\(alertMessage)")
        }


//        .sheet(isPresented: $viewModel.isShowingRental) {
//            RentalSheet(itemInfo: itemInfo, isRentalTerminal: $viewModel.isRentalTerminal)
//        }
    }

    @ViewBuilder
    private func CarouselImage() -> some View {
        TabView(selection: $viewModel.imageSelection) {
            ForEach(0..<5, id:\.self) { i in
                KFImage(URL(string: rentVM.productDetail.imagePath ?? ""))
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
        .isHidden(hidden: !isShowingModel)
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
        .shadow(color: Color.gray_495057, radius: 10, x: 0, y: 10)
    }
    
    @ViewBuilder
    private func ItemList() -> some View {
        Group {
            Text("물품목록")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(Color.gray_495057)
                .padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 0) {
                //  MARK: ITEM CELL
                ForEach(rentVM.productDetail.items.indices, id: \.self) { i in
                    let id = rentVM.productDetail.items[i].id
                    HStack {
                        
                        Button {
                            selctedItem = rentVM.productDetail.items[i]
                            selectedItemId = id
                            alertMessage = rentVM.productDetail.items[i].alertMessage
                        } label: {
                            Text("\(rentVM.productDetail.name) - \(rentVM.productDetail.items[i].numbering)")
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                                .foregroundColor(id == selectedItemId ? Color.white : Color.primary)
                            
                            Text("\(rentVM.productDetail.items[i].rentalPolicy)")
                                .font(.custom(CustomFont.RobotoBold.rawValue, size: 12))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(rentVM.productDetail.items[i].bgColor))
                        }
                        .frame(maxWidth:. infinity, alignment: .leading)
                        Spacer()
                        Text(rentVM.productDetail.items[i].status)
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                            .foregroundColor(id == selectedItemId ? Color.white : Color.primary)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(id == selectedItemId ? Color.navy_1E2F97 : Color.clear)
                    Divider()
                }
            }
        }
    }
    
    @ViewBuilder
    private func Caution() -> some View {
        Group {
            Text("사용 시 주의사항")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(Color.gray_495057)
            
            Text(rentVM.productDetail.caution)
                .padding(.horizontal, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray_F5F5F5))
        }
    }
    
    @ViewBuilder
    private func RentalButton() -> some View {
        HeightSetterView(viewHeight: $rentalButtonHeight) {
            Button {
                
                if let rentalInfo = selctedItem!.rentalInfo  {
                    //  대여자가 내가 아닐 경우 아무것도 하지 않음
                    if !rentalInfo.meRental {
                        callback = {
                            #if DEBUG
                            print("대여불가능")
                            #endif
                        }
                    } else if rentalInfo.rentalStatus == RentalStatus.wait.rawValue {
                        if locationManager.isAuthorized {
                            if locationManager.region.center.distance(from: rentVM.productLocation) > 30 {
                                locationManager.isPresentedDistanceAlert = true
                            } else {
                                isShowingAlert = true
                                callback = {
                                    Task {
                                        print("2번 콜백")
                                        await rentVM.applyRent(itemId: selectedItemId ?? -1)
                                        await clubVM.getMyRentals()
                                        await rentVM.getProduct()
                                        selctedItem = nil
                                        selectedItemId = nil
                                    }
                                }
                            }
                        } else {
                            locationManager.isPresentedAlert = true
                        }
                    } else if rentalInfo.rentalStatus == RentalStatus.rent.rawValue {
                        if locationManager.isAuthorized {
                            if locationManager.region.center.distance(from: rentVM.productLocation) > 30 {
                                locationManager.isPresentedDistanceAlert = true 
                            } else {
                                isShowingAlert = true
                                callback = {
                                    Task {
                                        print("3번 콜백")
                                        await rentVM.returnRent(itemId: selectedItemId ?? 0)
                                        await clubVM.getMyRentals()
                                        await rentVM.getProduct()
                                        selctedItem = nil
                                        selectedItemId = nil
                                    }
                                }
                            }
                        } else {
                            locationManager.isPresentedAlert = true
                        }
                    }
                } else {
                    isShowingAlert = true
                    callback = {
                        Task {
                            await rentVM.requestRent(itemId: selectedItemId ?? -1)
                            await clubVM.getMyRentals()
                            await rentVM.getProduct()
                            selctedItem = nil
                            selectedItemId = nil
                        }
                    }
                }
                
            } label: {
                Capsule()
                    .fill(selectedItemId == nil ? Color.BackgroundColor : Color.navy_1E2F97)
                    .overlay(Text(selctedItem?.buttonText ?? "대여하기")
                        .foregroundColor(selectedItemId == nil ? Color.navy_1E2F97 : Color.white)
                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20)))
                
                    .frame(height: 40)
            }
            .overlay(Capsule().stroke(Color.navy_1E2F97, lineWidth: 2))
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            .padding(.bottom, 5)
            .background(Color.BackgroundColor)
            .clipped()
            .shadow(color: Color.gray_495057, radius: 10, x: 0, y: 10)
            .disabled(selctedItem == nil)
        }
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
        .shadow(color: Color.gray_495057, radius: 10, x: 0, y: 10)
    }
    
    
    @ViewBuilder
    private func DatePickerOverlay() -> some View {
        VStack {
            Spacer()
            DatePicker("데이트 피커", selection: $viewModel.date)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    //  MARK: 삭제 예정
    
    
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
}

//struct Item_Previews: PreviewProvider {
//    static var previews: some View {
//        Item(itemInfo: RentalItemInfo.dummyRentalItem())
//    }
//}
