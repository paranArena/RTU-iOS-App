//
//  Protocols .swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/25.
//

import Foundation

protocol BaseAlert {
    var title: String { get }
    var message: String { get }
    var callback: () async -> () { get }
}

protocol BaseViewModel: ObservableObject {
    var twoButtonsAlert: TwoButtonsAlert { get set }
    var oneButtonAlert: OneButtonAlert { get set }
    var alertCase: BaseAlert? { get set }
    
    @MainActor func showAlert(with error: NetworkError)
    @MainActor func showOneButtonAlert(alertCase: BaseAlert)
    @MainActor func showTwoButtonsAlert(alertCase: BaseAlert)
}

extension BaseViewModel {
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    func showOneButtonAlert(alertCase: BaseAlert) {
        self.alertCase = alertCase
        if let alert = self.alertCase {
            oneButtonAlert.title = alert.title
            oneButtonAlert.messageText = alert.message
            oneButtonAlert.callback = {
                await alert.callback()
                self.alertCase = nil
            }
            oneButtonAlert.isPresented = true
        }
    }
}

class TestViewModel: BaseViewModel {
    var twoButtonsAlert: TwoButtonsAlert = TwoButtonsAlert()
    var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    var alertCase: BaseAlert?
    
    
    
    enum AlertCase: BaseAlert {
        case case1
        
        var title: String {
            switch self {
                
            case .case1:
                return "Title"
            }
        }
        
        var message: String {
            switch self {
                
            case .case1:
                return "Message"
            }
        }
        
        var callback: () async -> () {
            switch self {
                
            case .case1:
                return { print("callback") }
            }
        }
    }
    
}
