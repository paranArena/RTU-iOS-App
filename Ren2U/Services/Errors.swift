//
//  Erros.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/09.
//

import Foundation
import Alamofire

struct NetworkError: Error {
    let initialError: AFError?
    let serverError: ServerError?
}

struct ServerError: Decodable, Equatable{
    let code: String
    let message: String 
}

enum DateError: String, Error {
    case invalidDate
}
