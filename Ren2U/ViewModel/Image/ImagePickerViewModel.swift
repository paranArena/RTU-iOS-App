//
//  ImagePickerViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/11/16.
//

import SwiftUI
import AVFoundation

class ImagePickerViewModel: BaseViewModel {
    
    @Published var twoButtonsAlert: TwoButtonsAlert = TwoButtonsAlert()
    
    @Published var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    
    
    @Published var source: Picker.Source = .library
    @Published var isShowingDialog = false
    @Published var isShowingPicker = false
    @Published var isShowingAlert = false
    @Published var cameraError: Picker.CameraErrorType?
    
    let imageService: ImageServiceEnable
    
    init(imageService: ImageServiceEnable) {
        self.imageService = imageService
    }
    
    func showDialog() {
        self.isShowingDialog = true
    }
    
    func showCamera() {
        self.source = .camera
        do {
            try Picker.checkPermissions()
            self.isShowingPicker = true
        } catch {
            self.isShowingAlert = true
            cameraError = Picker.CameraErrorType(error: error as! Picker.PickerError)
        }
    }
    
    func showAlbum() {
        self.source = .library
        self.isShowingPicker = true
    }
    
    func upload(uiImage: UIImage) async -> String {
        let response = await imageService.upload(image: uiImage)
        
        if let error = response.error {
            await self.showAlert(with: error)
        } else if let value = response.value {
            return value.data ?? ""
        }
        
        return ""
    }
    
    enum Picker {
        enum Source: String {
            case library, camera
        }
        
        enum PickerError: Error, LocalizedError {
            case unavailable
            case restricted
            case denied
            
            var errorDescription: String? {
                switch self {
                case .unavailable:
                    return NSLocalizedString("디바이스에 카메라가 없습니다.", comment: "")
                case .restricted:
                    return NSLocalizedString("카메라를 사용할 수 없습니다.\n기기의 '설정 > Ren2U > 카메라'에서 카메라 서비스를 켜주세요.", comment: "")
                case .denied:
                    return NSLocalizedString("카메라를 사용할 수 없습니다.\n기기의 '설정 > Ren2U > 카메라'에서 카메라 서비스를 켜주세요.", comment: "")
                }
            }
        }
        
        static func checkPermissions() throws {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                switch authStatus {
                case .denied:
                    throw PickerError.denied
                case .restricted:
                    throw PickerError.restricted
                default:
                    break
                }
            } else {
                throw PickerError.unavailable
            }
        }
        
        struct CameraErrorType {
            let error: Picker.PickerError
            var message: String {
                error.localizedDescription
            }
            let button = Button("OK", role: .cancel) {}
        }
    }

}

