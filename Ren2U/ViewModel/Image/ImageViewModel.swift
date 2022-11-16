//
//  ImageViewModel.swift
//  Ren2U
//
//  Created by 노우영 on 2022/09/20.
//

import Foundation
import SwiftUI
import Alamofire

//  Image 업로드 후 url을 가져오기 위한 뷰모델
class ImageViewModel: ObservableObject {

    func upload(uiImage: UIImage) async -> String {
        let url = "\(BASE_URL)/image/upload"
        let hearders: HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")",
            "Content-type": "multipart/form-data"
        ]

        let task = AF.upload(multipartFormData: { multipart in
            if let image = uiImage.jpegData(compressionQuality: 1) {
                multipart.append(image, withName: "thumbnail", fileName: "filename", mimeType: "image/jpeg")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: hearders).serializingDecodable(String.self)

        let response = await task.response

        return response.value ?? ""
    }
}
