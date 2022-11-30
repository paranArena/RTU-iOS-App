//
//  Protocols .swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/25.
//

import Foundation

protocol AlertDelegate: ObservableObject {
    var alert: CustomAlert { get set }
    var alertCase: (any BaseAlert)? { get set }
    
    func showAlert(with error: NetworkError)
    func showAlert(alertCase: any BaseAlert)
    func showAlertWithCancelButton(alertCase: any BaseAlert)
}

extension AlertDelegate {
    func showAlert(with error: NetworkError) {
        self.alert.titleText = "에러"
        self.alert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        self.alert.isPresentedCancelButton = false
        self.alert.isPresentedAlert = true
        self.alert.callback = {
            self.alertCase = nil 
        }
        
    }
    
    @MainActor
    func showAlert(alertCase: any BaseAlert) {
        self.alertCase = alertCase
        if let ac = self.alertCase {
            self.alert.titleText = ac.title
            self.alert.messageText = ac.message
            self.alert.callback = {
                await ac.callback()
                self.alertCase = nil
            }
            self.alert.isPresentedCancelButton = false
            self.alert.isPresentedAlert = true
        }
    }
    
    @MainActor
    func showAlertWithCancelButton(alertCase: any BaseAlert) {
        self.alertCase = alertCase
        if let ac = self.alertCase {
            alert.titleText = ac.title
            alert.messageText = ac.message
            alert.isPresentedCancelButton = true
            alert.isPresentedAlert = true
            alert.callback = {
                await ac.callback()
                self.alertCase = nil
            }
        }
    }
}

protocol BaseViewModel: ObservableObject {
    var twoButtonsAlert: TwoButtonsAlert { get set }
    var oneButtonAlert: OneButtonAlert { get set }
    @MainActor func showAlert(with error: NetworkError)
}

