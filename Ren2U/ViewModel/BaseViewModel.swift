//
//  Protocols .swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/25.
//

import Foundation

protocol BaseViewModel: ObservableObject {
    var twoButtonsAlert: TwoButtonsAlert { get set }
    var oneButtonAlert: OneButtonAlert { get set }
    @MainActor func showAlert(with error: NetworkError)
}
