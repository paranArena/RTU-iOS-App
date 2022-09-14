//
//  ItemMapViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/13.
//

import SwiftUI
import Alamofire

class ItemMapViewModel: ObservableObject {
    
    @Published var alert = Alert() 
    
    
    func applyRent(clubId: Int, itemId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubId)/rentals/\(itemId)/apply"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "")]
        
        let request = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
            
        switch result {
        case .success(let value):
            print("[applyRent success]")
            print(value)
        case .failure(let err):
            print("[applyRent failure]")
            print(err)
        }
    }
    
    func returnRent(clubId: Int, itemId: Int) async {
        let url = "\(BASE_URL)/clubs/\(clubId)/rentals/\(itemId)/return"
        let hearders: HTTPHeaders = [.authorization(bearerToken: UserDefaults.standard.string(forKey: JWT_KEY) ?? "" )]
        
        let request = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: hearders).serializingString()
        let result = await request.result
            
        switch result {
        case .success(let value):
            print("[returnRent success]")
            print(value)
        case .failure(let err):
            print("[returnRent failure]")
            print(err)
        }
    }
}
