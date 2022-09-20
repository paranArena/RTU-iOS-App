//
//  UpdateClubInfoViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import Foundation
import Alamofire

class UpdateClubInfoViewModel: ObservableObject {
    
    var clubId: Int?
    
    @Published var clubParam = ClubDetailParam()
    @Published var tagsText = ""
    @Published var isShowingImagePicker = false
    @Published var isShowingTagPlaceholder = true
    
    @Published var isLoading = true
    @Published var alert = Alert()
    @Published var oneButtonAlert = OneButtonAlert()
    
    init() {
        isLoading = false
    }
    
    init(clubId: Int) {
        self.clubId = clubId
        
        Task {
            await getClubInfo()
            self.isLoading = false
        }
    }
    
    
    @MainActor
    private func getClubInfo() async {
        let url = "\(BASE_URL)/clubs/\(clubId)/info"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY)!)]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetClubInfoResponse.self)
        let response = await request.response
        
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 200:
                print("getClubInfo success")
                let clubDetailData = response.value?.data ?? ClubDetailData.dummyClubData()
                self.clubParam = ClubDetailParam(clubData: clubDetailData)
            default:
                print("getClubInfo err")
                print(response.debugDescription)
            }
        }
    }
}
