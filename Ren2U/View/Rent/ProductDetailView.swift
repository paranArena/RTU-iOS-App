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
    
    @Environment(\.isPresented) var isPresented
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var clubVM: ClubViewModel
    @StateObject private var rentVM: RentalViewModel
//    @StateObject private var viewModel = ViewModel()
    
    @State private var rentalButtonHeight: CGFloat = .zero
    @State private var offset: CGFloat = .zero
    
    init(clubId: Int, productId: Int) {
        self.clubId = clubId
        self.productId = productId
        _rentVM = StateObject(wrappedValue: RentalViewModel(clubId: clubId, productId: productId))
    }
    
    

    
    var body: some View {
        BounceControllScrollView(baseOffset: -10, offset: $offset) {
            VStack(alignment: .leading, spacing: 10) {
                
                KFImage(URL(string: rentVM.productDetail.imagePath ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: SCREEN_WIDTH, height: 300)
                    .clipped()
                
                Group {
                    Text("REN2U")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))

                    Text(rentVM.productDetail.name)
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 26))

                    Divider()
                    
                    ProductCategory()
                    ProductPrice()
                }
                .padding(.horizontal, 10)
                    
                ItemList()
                Caution()

                NavigationLink("", isActive: $rentVM.isRentalTerminal) {
                    RentalComplete(itemInfo: rentVM.productDetail, itemNumber: rentVM.selectedItem?.numbering ?? 0)
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
        .basicNavigationTitle(title: rentVM.productDetail.name)
        .alert(rentVM.oneButtonAlert.title, isPresented: $rentVM.oneButtonAlert.isPresented) {
            OneButtonAlert.okButton
        } message: { rentVM.oneButtonAlert.message }
        .alert("", isPresented: $rentVM.alert.isPresented) {
            Button("취소", role: .cancel) {}
            Button("확인")  {
                Task {
                    rentVM.alert.callback()
                    await clubVM.getMyRentals()
                }
            }
        } message: {
            Text("\(rentVM.alert.title)")
        }
    }
    
    @ViewBuilder
    private func ProductCategory() -> some View {
        HStack {
            Text("카테고리")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(Color.gray_495057)

            Spacer()

            Text(rentVM.productDetail.category)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
        }
    }
    
    @ViewBuilder
    private func ProductPrice() -> some View {
        HStack {
            Text("물품가치")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(Color.gray_495057)
            
            Spacer()
            
            Text("\(rentVM.productDetail.price)")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
        }
    }

//    @ViewBuilder
//    private func CarouselImage() -> some View {
//        TabView(selection: $viewModel.imageSelection) {
//            ForEach(0..<5, id:\.self) { i in
//                KFImage(URL(string: rentVM.productDetail.imagePath ?? ""))
//                    .onFailure { err in
//                        print(err.errorDescription ?? "KFImage Optional err")
//                    }
//                    .resizable()
//                    .frame(width: SCREEN_WIDTH, height: 300)
//                    .tag(i)
//
//            }
//        }
//        .animation(viewModel.imageSelection == 0 ? nil : .spring(), value: viewModel.imageSelection)
//        .frame(height: 300)
//        .tabViewStyle(PageTabViewStyle())
//    }
    
    
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
                            rentVM.selectedItem = rentVM.productDetail.items[i]
                        } label: {
                            Text("\(rentVM.productDetail.name) - \(rentVM.productDetail.items[i].numbering)")
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                                .foregroundColor(id == rentVM.selectedItem?.id ? Color.white : Color.primary)
                            
                            Text("\(rentVM.productDetail.items[i].rentalPolicy)")
                                .font(.custom(CustomFont.RobotoBold.rawValue, size: 12))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(rentVM.productDetail.items[i].bgColor))
                                .frame(maxWidth:. infinity, alignment: .leading)
                            
                            Text(rentVM.productDetail.items[i].status)
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                                .foregroundColor(id == rentVM.selectedItem?.id ? Color.white : Color.primary)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(id == rentVM.selectedItem?.id ? Color.navy_1E2F97 : Color.clear)
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
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    private func RentalButton() -> some View {
        HeightSetterView(viewHeight: $rentalButtonHeight) {
            Button {
                if rentVM.selectedItem?.rentalInfo == nil {
                    rentVM.setAlert()
                } else if locationManager.checkDistance(productRegion: rentVM.productLocation) {
                    rentVM.setAlert()
                }
            } label: {
                Capsule()
                    .fill(rentVM.selectedItem?.mainButtonFillColor ?? Color.BackgroundColor)
                    .overlay(Text(rentVM.selectedItem?.buttonText ?? "물품을 선택하세요.")
                        .foregroundColor(rentVM.selectedItem?.mainButtonFGColor ?? Color.navy_1E2F97)
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
            .disabled(rentVM.selectedItem?.mainButtonDisable ?? true)
        }
    }
            

    //  MARK: 삭제 예정
    
//    @ViewBuilder
//    private func ReturnOverlayButton() -> some View {
//        HStack(alignment: .center, spacing: 20) {
//            VStack(alignment: .center, spacing: 5) {
//                Text("반납 예정일")
//                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
//
//                Text(viewModel.formatReturnDate(Date.now))
//                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 22))
//            }
//
//            Button {
//
//            } label: {
//                Text("반납하기")
//                    .frame(maxWidth: .infinity, minHeight: 50)
//                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
//                    .foregroundColor(Color.white)
//                    .background(Capsule().fill(Color.navy_1E2F97))
//            }
//        }
//        .padding([.horizontal, .bottom], 20)
//        .padding(.top, 10)
//        .background(Color.BackgroundColor)
//        .frame(maxWidth: .infinity)
//        .clipped()
//        .shadow(color: Color.gray_495057, radius: 10, x: 0, y: 10)
//    }
    
    
//    @ViewBuilder
//    private func DatePickerOverlay() -> some View {
//        VStack {
//            Spacer()
//            DatePicker("데이트 피커", selection: $viewModel.date)
//        }
//        .edgesIgnoringSafeArea(.bottom)
//    }
    
    
//    @ViewBuilder
//    private func RentalCompleteOverlayButton() -> some View {
//        HStack(alignment: .center, spacing: 20) {
//            VStack(alignment: .center, spacing: 5) {
//                Text("픽업일정")
//                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
//
//                Text(viewModel.formatPickUpDate(Date.now))
//                    .font(.custom(CustomFont.RobotoMedium.rawValue, size: 22))
//            }
//
//            Button {
//
//            } label: {
//                Text("대여 확정")
//                    .frame(maxWidth: .infinity, minHeight: 50)
//                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
//                    .foregroundColor(Color.white)
//                    .background(Capsule().fill(Color.navy_1E2F97))
//            }
//        }
//        .padding([.horizontal, .bottom], 20)
//        .padding(.top, 10)
//        .background(Color.BackgroundColor)
//        .frame(maxWidth: .infinity)
//        .clipped()
//        .shadow(color: Color.gray_495057, radius: 10, x: 0, y: 10)
//    }
//
    
//    @ViewBuilder
//    private func QueueSelectButton() -> some View {
//        Button  {
//            if viewModel.selection != .queue {
//                viewModel.selection = .queue
//            } else {
//                viewModel.selection = .none
//            }
//
//        } label: {
//            VStack(alignment: .center) {
//                Text("선착순")
//                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
//
//                Text("바로 대여가 가능합니다.")
//                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
//            }
//            .foregroundColor(viewModel.selection == .queue ? Color.BackgroundColor : Color.LabelColor)
//        }
//        .frame(maxWidth: SCREEN_WIDTH, minHeight: 120)
//        .background(viewModel.selection == .queue ? Color.navy_1E2F97 : Color.gray_F8F9FA)
//    }
    
//    @ViewBuilder
//    private func TermSelectButton() -> some View {
//        Button {
//            if viewModel.selection != .term {
//                viewModel.selection = .term
//            } else {
//                viewModel.selection = .none
//            }
//        } label: {
//            VStack {
//                Text("기간제")
//                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
//
//                Text("일정기간 대여가 가능합니다.")
//                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
//            }
//            .foregroundColor(viewModel.selection == .term ? Color.BackgroundColor : Color.LabelColor)
//        }
//        .frame(maxWidth: SCREEN_WIDTH, minHeight: 120)
//        .background(viewModel.selection == .term ? Color.navy_1E2F97 : Color.gray_F8F9FA)
//    }
}

//struct Item_Previews: PreviewProvider {
//    static var previews: some View {
//        Item(itemInfo: RentalItemInfo.dummyRentalItem())
//    }
//}
