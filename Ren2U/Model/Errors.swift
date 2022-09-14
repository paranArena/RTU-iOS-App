//
//  Erros.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/09.
//

import SwiftUI

struct ErrorBody: Decodable {
    let code: String
    let message: String 
}

enum DateError: String, Error {
    case invalidDate
}
