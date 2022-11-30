//
//  MemberService .swift
//  Ren2U
//
//  Created by 노우영 on 2022/10/14.
//

import Alamofire
import Foundation

protocol MemberServiceEnable: BaseServiceEnable {
    
    //  MARK: Deprecated
    func login(param: [String: Any]) async -> DataResponse<LoginResponse, NetworkError>
    @discardableResult func login(data: LoginParam) async -> DataResponse<LoginResponse, NetworkError>
    func checkEmailDuplicate(email: String) async -> DataResponse<Bool, NetworkError>
    func getMyInfo() async -> DataResponse<GetMyInfoResponse, NetworkError>
    func getMyClubs() async -> DataResponse<GetMyClubsResponse, NetworkError>
    func getMyRentals() async -> DataResponse<GetMyRentalsResponse, NetworkError>
    func getMyNotifications() async -> DataResponse<GetMyNotificationsResponse, NetworkError>
    func getMyProducts() async -> DataResponse<GetMyProductsResponse, NetworkError>
    func getMyCouponsAll() async -> DataResponse<GetMyCouponsAllResponse, NetworkError>
    func getMyCouponHistoriesAll() async -> DataResponse<GetMyCouponHistoriesAllResponse, NetworkError>
    func quitService() async -> DataResponse<DefaultPostResponse, NetworkError>
    func checkPhoneStudentIdDuplicate(phoneNumber: String, studentId: String) async -> DataResponse<CheckPhoneStudentIdDuplicateResponse, NetworkError>
    
    func requestEmailCode(email: String) async -> DataResponse<DefaultPostResponse, NetworkError>
    func signUp(data: SignUpParam) async -> DataResponse<SignUpResponse, NetworkError>
    func passwordResetWithVerficationCode(data: PasswordResetParam) async -> DataResponse<DefaultPostResponse, NetworkError>
}

class MockupMemberService: MemberServiceEnable {
    var bearerToken: String?
    var url: String?
    
    func passwordResetWithVerficationCode(data: PasswordResetParam) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        let result = Result {
            return DefaultPostResponse(statusCode: 200, responseMessage: "", data: nil)
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    
    func login(data: LoginParam) async -> Alamofire.DataResponse<LoginResponse, NetworkError> {
        let result = Result {
            return LoginResponse(token: "")
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    
    func signUp(data: SignUpParam) async -> Alamofire.DataResponse<SignUpResponse, NetworkError> {
        let result = Result {
            return SignUpResponse(statusCode: 200, responseMessage: "", data: UserData.dummyUserData())
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func requestEmailCode(email: String) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        let result = Result {
            return DefaultPostResponse(statusCode: 200, responseMessage: "", data: nil)
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func passwordResetWithVerificationCode(param: [String: Any]) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        let result = Result {
            return DefaultPostResponse(statusCode: 200, responseMessage: "", data: nil)
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    
    func checkPhoneStudentIdDuplicate(phoneNumber: String, studentId: String) async -> Alamofire.DataResponse<CheckPhoneStudentIdDuplicateResponse, NetworkError> {
        let result = Result {
            return CheckPhoneStudentIdDuplicateResponse(statusCode: 200, responseMessage: "", data: DuplicateCheckData.dummyDuplicateCheckData())
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func login(param: [String : Any]) async -> Alamofire.DataResponse<LoginResponse, NetworkError> {
        let result = Result {
            return LoginResponse(token: "error token")
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func getMyInfo() async -> Alamofire.DataResponse<GetMyInfoResponse, NetworkError> {
        let result = Result {
            return GetMyInfoResponse(statusCode: 200, responseMessage: "", data: UserData.dummyUserData())
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func getMyClubs() async -> Alamofire.DataResponse<GetMyClubsResponse, NetworkError> {
        let result = Result {
            return GetMyClubsResponse(statusCode: 200, responseMessage: "", data: ClubAndRoleData.dummyClubAndRoleDatas())
        }.mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func getMyRentals() async -> Alamofire.DataResponse<GetMyRentalsResponse, NetworkError> {
        let result = Result {
            return GetMyRentalsResponse(statusCode: 200, responseMessage: "", data: RentalData.dummyRentalDatas())
        }.mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func getMyNotifications() async -> Alamofire.DataResponse<GetMyNotificationsResponse, NetworkError> {
        let result = Result {
            return GetMyNotificationsResponse(statusCode: 200, responseMessage: "", data: NotificationPreviewData.dummyNotifications())
        }.mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0.0, result: result)
    }
    
    func getMyProducts() async -> Alamofire.DataResponse<GetMyProductsResponse, NetworkError> {
        let result = Result {
            return GetMyProductsResponse(statusCode: 200, responseMessage: "", data: ProductPreviewDto.dummyProductPreviewDtoDatas())
        }.mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0.0, result: result)
    }
    
    func getMyCouponsAll() -> Alamofire.DataResponse<GetMyCouponsAllResponse, NetworkError> {
        let result = Result {
            return GetMyCouponsAllResponse(statusCode: 200, responseMessage: "", data: CouponPreviewData.dummyCouponPreviewDatas())
        }.mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0.0, result: result)
    }
    
    func getMyCouponHistoriesAll() -> Alamofire.DataResponse<GetMyCouponHistoriesAllResponse, NetworkError> {
        let result = Result {
            return GetMyCouponHistoriesAllResponse(statusCode: 200, responseMessage: "", data: CouponPreviewData.dummyCouponPreviewDatas())
        }.mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0.0, result: result)
    }
    
    func quitService() -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        let result = Result {
            return DefaultPostResponse(statusCode: 200, responseMessage: "", data: nil)
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    func checkEmailDuplicate(email: String) -> Alamofire.DataResponse<Bool, NetworkError> {
        let result = Result {
            return true
        } .mapError { _ in
            NetworkError(initialError: nil, serverError: nil)
        }
        
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
    }
    
    
}

class MemberService: MemberServiceEnable {

    let url: String?
    var bearerToken: String?
    
    init(url: String) {
        self.url = url
        self.bearerToken = UserDefaults.standard.string(forKey: JWT_KEY)
    }
    
    func passwordResetWithVerficationCode(data: PasswordResetParam) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        
        let url = "\(self.url!)/password/reset/verify"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        let param: [String: Any] = [
            "email" : data.email,
            "code" : data.code,
            "password" : data.password
        ]
        
        let response = await AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    
    func signUp(data: SignUpParam) async -> Alamofire.DataResponse<SignUpResponse, NetworkError> {
        
        let url = "\(self.url!)/signup"
        let param: [String: Any] = [
            "email" : data.email,
            "password" : data.password,
            "name" : data.name,
            "phoneNumber" : data.phoneNumber,
            "studentId" : data.studentId,
            "major" : data.major,
            "verificationCode" : data.code
        ]
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingDecodable(SignUpResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    
    func requestEmailCode(email: String) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        
        let url = "\(self.url!)/members/email/requestCode"
        let param: [String: Any] = ["email" : email]
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    
    func passwordResetWithVerificationCode(param: [String: Any]) async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {
        
        let url = "\(url!)/password/reset/verify"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: self.bearerToken!)
        ]
        
        let response = await AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    
    
    func checkPhoneStudentIdDuplicate(phoneNumber: String, studentId: String) async -> Alamofire.DataResponse<CheckPhoneStudentIdDuplicateResponse, NetworkError> {
        let url = "\(url!)/members/duplicate/010\(phoneNumber)/\(studentId)/exists"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: bearerToken ?? "")
        ]
        
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).serializingDecodable(CheckPhoneStudentIdDuplicateResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    
    func getMyInfo() async -> Alamofire.DataResponse<GetMyInfoResponse, NetworkError> {
        let url = "\(url!)/members/my/info"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyInfoResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func login(param: [String : Any]) async -> Alamofire.DataResponse<LoginResponse, NetworkError> {
        let url = "\(url!)/authenticate"
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingDecodable(LoginResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func login(data: LoginParam) async -> Alamofire.DataResponse<LoginResponse, NetworkError> {
        let url = "\(url!)/authenticate"
        let param = [
            "email" : data.email,
            "password" : data.password
        ]
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingDecodable(LoginResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getMyClubs() async -> Alamofire.DataResponse<GetMyClubsResponse, NetworkError> {
        let url = "\(url!)/members/my/clubs"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyClubsResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getMyRentals() async -> Alamofire.DataResponse<GetMyRentalsResponse, NetworkError> {
        let url = "\(url!)/members/my/rentals"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyRentalsResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getMyNotifications() async -> Alamofire.DataResponse<GetMyNotificationsResponse, NetworkError> {
        let url = "\(url!)/members/my/notifications"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyNotificationsResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getMyProducts() async -> Alamofire.DataResponse<GetMyProductsResponse, NetworkError> {
        let url = "\(url!)/members/my/products"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyProductsResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getMyCouponsAll() async -> Alamofire.DataResponse<GetMyCouponsAllResponse, NetworkError> {
        let url = "\(url!)/members/my/coupons/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyCouponsAllResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func getMyCouponHistoriesAll() async -> Alamofire.DataResponse<GetMyCouponHistoriesAllResponse, NetworkError> {
        let url = "\(url!)/members/my/couponHistories/all"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetMyCouponHistoriesAllResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func quitService() async -> Alamofire.DataResponse<DefaultPostResponse, NetworkError> {

        let url = "\(url!)/members/my/quit"
        let hearders: HTTPHeaders = [.authorization(bearerToken: self.bearerToken ?? "")]
        
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(DefaultPostResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
    func checkEmailDuplicate(email: String) async -> Alamofire.DataResponse<Bool, NetworkError> {
        
        let url = "\(url!)/members/email/\(email)/exists"

        let response = await AF.request(url, method: .get).serializingDecodable(Bool.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
    
}

