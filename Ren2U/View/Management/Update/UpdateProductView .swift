//
//  UpdateProductView .swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import SwiftUI

struct UpdateProductView: View {
    
    @StateObject var updateProductVM: UpdateProductViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                ProductName()
                ProductCategory()
                ProductPrice()
                Items()
                RentalPeriod()
                ProductLocation()
                Caution()
            }
            .padding(.horizontal)
        }
        .alert(updateProductVM.oneButtonAlert.title, isPresented: $updateProductVM.oneButtonAlert.isPresented) {
            OneButtonAlert.noActionButton
        } message: {
            updateProductVM.oneButtonAlert.message
        }
        .basicNavigationTitle(title: "물품 정보 수정")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("완료")
                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 18))
            }
        }
    }
    
    @ViewBuilder
    private func ProductName() -> some View {
        Group {
            Text("물품 이름")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
            
            TextField("", text: $updateProductVM.productDetailData.name)
                .background(alignment: .bottom) {
                    SimpleLine(color: .gray_DEE2E6)
                }
        }
    }
    
    @ViewBuilder
    private func ProductCategory() -> some View {
        Group {
            Text("카테고리")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
            
            NavigationLink {
                ItemCategory(category: $updateProductVM.productDetailData.category)
            } label: {
                Text(updateProductVM.productDetailData.category)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                    .frame(width: 150, height: 30)
                    .foregroundColor(.primary)
                    .background(Color.gray_F1F2F3)
                    .cornerRadius(5)
            }
        }
    }
    
    @ViewBuilder private func RentalPeriod() -> some View {
        Group {
            Text("최대 대여기간 설정")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
            
            HStack(alignment: .center, spacing: 0) {
                Text("선착순")
                
                Spacer()
                
                TextField("", text: $updateProductVM.fifoRentalPeriod)
                    .multilineTextAlignment(.trailing)
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 24))
                    .keyboardType(.numberPad)
                
                Text("일")
                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
            }
            
        }
    }
    
    @ViewBuilder
    private func ProductPrice() -> some View {
        Group {
            Text("물품 가치")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
            
            TextField("", text: $updateProductVM.price)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
        }
    }
    
    @ViewBuilder
    private func Items() -> some View {
        Group {
            
            Text("물품 목록")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
            
            ForEach(updateProductVM.productDetailData.items.indices, id: \.self) { i in
                VStack {
                    HStack {
                        Text("\(updateProductVM.productDetailData.name) - \(updateProductVM.productDetailData.items[i].numbering)")
                            .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("삭제")
                                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(Color.navy_1E2F97))
                        }

                    }
                    
                    Divider()
                }
            }
        }
    }
    
    @ViewBuilder
    private func ProductLocation() -> some View {
        Group {
            Text("픽업장소")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
            
            TextField("", text: $updateProductVM.productDetailData.location.name)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
        }
    }
    
    @ViewBuilder private func Caution() -> some View {
        Group {
            Text("사용시 주의사항")
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 12))
                .foregroundColor(.gray_495057)
            
            TextEditor(text: $updateProductVM.productDetailData.caution)
                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 14))
                .padding(.horizontal)
                .padding(.vertical)
                .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray_DEE2E6, lineWidth: 2))
        }
    }
}
//
//struct UpdateProductView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateProductView()
//    }
//}
