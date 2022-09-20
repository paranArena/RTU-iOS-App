////
////  UpdateClubView.swift
////  Ren2U
////
////  Created by 노우영 on 2022/09/20.
////
//
//import SwiftUI
//
//struct UpdateClubView: View {
//    
//    @StateObject var updateClubVM: UpdateClubInfoViewModel
//    @State private var tmp: CGFloat = .zero
//    var body: some View {
//        BounceControllScrollView(baseOffset: 80, offset: $tmp) {
//            VStack(alignment: .center, spacing: 10) {
//                //                GroupImage()
//                //                    .overlay(ChangeImageButton())
//                
//                VStack(alignment: .leading, spacing: 70) {
//                    ClubName()
//                    Tags()
//                    //                    Tags()
//                    //                    Introduction()
//                }
//                .padding(.horizontal, 10)
//                
//            }
//        }
//        //        .alert(clubVM.oneButtonAlert.title, isPresented: $clubVM.oneButtonAlert.isPresented) {
//        //            OneButtonAlert.noActionButton
//        //        } message: {
//        //            clubVM.oneButtonAlert.message
//        //        }
//        //        .toolbar {
//        //            ToolbarItemGroup(placement: .principal) {
//        //                Text("그룹등록")
//        //                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 20))
//        //            }
//        
//        //            ToolbarItemGroup(placement: .navigationBarTrailing) {
//        //                CreateCompleteButton()
//        //            }
//        //        }
//    }
//    
//    @ViewBuilder private func ClubName() -> some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("그룹 이름")
//                .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
//                .foregroundColor(Color.gray_495057)
//            
//            TextField("", text: $updateClubVM.clubData.name)
//                .font(.custom(CustomFont.RobotoRegular.rawValue, size: 30))
//                .overlay(SimpleBottomLine(color: Color.gray_DEE2E6))
//        }
//    }
//    
//    @ViewBuilder private func Tags() -> some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Group {
//                Text("태그")
//                    .font(.custom(CustomFont.NSKRMedium.rawValue, size: 16))
//                    .foregroundColor(Color.gray_495057)
//                
//                ZStack(alignment: .leading) {
//                    Text("#렌탈 #서비스는 #REN2U")
//                        .foregroundColor(.gray_ADB5BD)
//                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
//                        // MARK: hidden 조건 추가하기
//
//                    
//                    TextField("", text: $updateClubVM.tagsText)
//                        .font(.custom(CustomFont.NSKRRegular.rawValue, size: 20))
//                        .onChange(of: focusField) { newValue in
//                            viewModel.parsingTag()
//                            viewModel.showTagPlaceHolder(newValue: newValue)
//                        }
//                }
//                .overlay(
//                    VStack {
//                        Spacer()
//                        Rectangle()
//                            .frame(height: 1)
//                            .foregroundColor(Color.gray_ADB5BD)
//                    }
//                )
//                
//                Text("#과 띄어쓰기를 포함해 영어는 최대 36글자, 한글은 24글자까지 가능합니다.")
//                    .font(.custom(CustomFont.NSKRRegular.rawValue, size: 10))
//                    .foregroundColor(Color.gray_ADB5BD)
//                    .padding(.top, -10)
//            }
//            .onTapGesture {
//                focusField = .tagsText
//                viewModel.isShowingTagPlaceholder = false
//            }
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack {
//                    ForEach(viewModel.clubProfileData.hashtags.indices, id: \.self) { i in
//                        HStack {
//                            Text("#\(viewModel.clubProfileData.hashtags[i])")
//                                .font(.custom(CustomFont.NSKRRegular.rawValue, size: 16))
//                            
//                            Button {
//                                viewModel.clubProfileData.hashtags.remove(at: i)
//                            } label: {
//                                Image(systemName: "xmark")
//                                    .resizable()
//                                    .frame(width: 10, height: 10)
//                            }
//                        }
//                        .padding(.vertical, 5)
//                        .padding(.horizontal, 10)
//                        .overlay(Capsule().stroke(lineWidth: 1))
//                    }
//                }
//                .foregroundColor(Color.gray_495057)
//            }
//        }
//    }
//}
//
////struct UpdateClubView_Previews: PreviewProvider {
////    static var previews: some View {
////        UpdateClubView()
////    }
////}
