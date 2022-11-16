//
//  BaseService .swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/14.
//

import Foundation

protocol BaseServiceEnable {
    var url: String? { get }
    var bearerToken: String? { get set }
}
