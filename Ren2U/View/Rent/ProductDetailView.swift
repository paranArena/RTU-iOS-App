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
import MapKit

struct ProductDetailView: View {
    
    let clubId: Int
    let productId: Int
    
    @Environment(\.isPresented) var isPresented
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var clubVM: ClubViewModel
    @StateObject private var rentVM: RentalViewModel
    
    @State private var rentalButtonHeight: CGFloat = .zero
    @State private var offset: CGFloat = .zero
    
    init(clubId: Int, productId: Int) {
        self.clubId = clubId
        self.productId = productId
        _rentVM = StateObject(wrappedValue: RentalViewModel(clubId: clubId, productId: productId,
                                                            rentService: RentService(url: ServerURL.runningServer.url),
                                                            clubProductService: ClubProductService(url: ServerURL.runningServer.url)))
    }
    
    

    
    var body: some View {
        BounceControllScrollView(baseOffset: -10, offset: $offset) {
            VStack(alignment: .leading, spacing: 15) {
                
                KFImage(URL(string: rentVM.productDetail.imagePath ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: SCREEN_WIDTH, height: SCREEN_WIDTH)
                    .clipped()
                
                Group {
                    Text("REN2U")
                        .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                    
                    HStack {
                        Text(rentVM.productDetail.name)
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 26))
                        Spacer()
                        ShowMapButton()
                    }

                    Divider()
                    
                    ProductCategory()
                    ProductPrice()
                    RentalDuration()
                    Caution()
                }
                .padding(.horizontal, 10)
                
                ItemList()

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
        .onAppear {
            rentVM.selectedItem = nil
        }
        .alert(rentVM.twoButtonsAlert.title, isPresented: $rentVM.twoButtonsAlert.isPresented) {
            Button("취소", role: .cancel) {}
            Button("확인") {
                Task {
                    await rentVM.twoButtonsAlert.callback()
                    await clubVM.getMyRentals()
                }
            }
        } message: { rentVM.twoButtonsAlert.message }
        .alert(rentVM.oneButtonAlert.title, isPresented: $rentVM.oneButtonAlert.isPresented) {
            Button("확인") { Task { await self.rentVM.oneButtonAlert.callback() }}
        } message: { rentVM.oneButtonAlert.message }
    }
    
    @ViewBuilder
    private func ShowMapButton() -> some View {
        if rentVM.productDetail.isThereLocationRestriction {
            Button {
                rentVM.setLocation()
                rentVM.isPresentedMap = true
            } label: {
                Text("위치보기")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 18))
                    .foregroundColor(.gray_495057)
                
            }
            .sheet(isPresented: $rentVM.isPresentedMap) {
                VStack {
                    TransparentDivider()
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: rentVM.productLocation, span: DEFAULT_SPAN)), showsUserLocation: true, annotationItems: [Annotation(coordinate: rentVM.productLocation)]) { annotation in
                        MapAnnotation(coordinate: annotation.coordinate) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.navy_1E2F97)
                        }
                    }
                }
            }
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
    
    @ViewBuilder
    private func RentalDuration() -> some View {
        HStack {
            Text("대여기간")
                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 14))
                .foregroundColor(Color.gray_495057)
            
            Spacer()
            
            Text("\(rentVM.productDetail.fifoRentalPeriod)일")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
        }
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
                            rentVM.itemCellTapped(item: rentVM.productDetail.items[i])
                        } label: {
                            Text("\(rentVM.productDetail.name) - \(rentVM.productDetail.items[i].numbering)")
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                                .lineLimit(1)
                                .foregroundColor(id == rentVM.selectedItem?.id ? Color.white : Color.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("\(rentVM.productDetail.items[i].rentalPolicy)")
                                .font(.custom(CustomFont.RobotoBold.rawValue, size: 12))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(rentVM.productDetail.items[i].bgColor))
//                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
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
    }
    
    @ViewBuilder
    private func RentalButton() -> some View {
        HeightSetterView(viewHeight: $rentalButtonHeight) {
            Button {
                if rentVM.selectedItem?.rentalInfo == nil {
                    rentVM.rentButtonTapped()
                } else if locationManager.checkDistance(productRegion: rentVM.productLocation) {
                    rentVM.rentButtonTapped()
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
}

//struct Item_Previews: PreviewProvider {
//    static var previews: some View {
//        Item(itemInfo: RentalItemInfo.dummyRentalItem())
//    }
//}
