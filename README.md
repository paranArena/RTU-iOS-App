# Dependency Injection 

[이곳](https://jacobko.info/swiftui/swiftui-35/)을 참고한 글. 

[노션](https://mud-climb-89a.notion.site/DIP-DI-7fa8616b54574746b3ab055f17565ba5)에는 실제 적용이 아닌 더 이론적인 부분을 작성. 
```swift 
 class CouponService {
    static let shared = CouponService()
    private init() { }
    //  생략
}

class CouponViewModel: ObservableObject, BaseViewModel {
    let couponService = CouponService.shard 
    // 생략
}
```

기존에는 api통신을 하기위한 기능들을 service class에서 만들어 싱글톤으로 이용했다. 싱글톤은 배우는 과정에서는 편하지만 몇가지 문제점이 있다. 

1. 싱글톤은 전역으로(GLOBAL) 이용된다.
   
   싱글톤이 사용된 인스턴스는 어디서든 접근이 가능하다. 앱이 커지면 많은 전역 변수가 생겨 혼란스러울 수 있다. 그리고 같은 싱글톤 인스턴스가 멀티 쓰레드 환경에서 이용되고 동시에 접근이 된다면 크래시가 발생될 우려가 있다. 

2. 이시녈라이저를 커스텀할 수 없다. 

    테스트할 때 패러미터를 이용한 초기화는 중요한데 싱글톤을 이용하면 패러미터를 전달할 수 없다.

3. 의존성(dependency)를 변경할 수 없다. 

    Dependency Injection을 하는 목적과 연관이 크다. Dependency Injection을 할 경우 어떤 이점이 있는지는 아래에 작성할 것이다. 



```swift
protocol CouponServiceProtocol {
    func getClubCouponsAdmin(clubId: Int) async -> DataResponse<GetClubCouponsAdminResponse, NetworkError>
    func getCouponAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponAdminResponse, NetworkError>
    func getCouponMembersAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponMembersAdmin, NetworkError>
    func getCouponMembersHistoriesAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponMembersHistoriesAdmin, NetworkError>
    // 생략 
}
```

이런식으로 포토콜을 생성해준다. 기존의 내 코드는 `viewModel->service` 로 의존관계가 있었다면 이제는 `viewModel->protocol<-service` 의 의존 관계를 만들어줄 것이다. 객체지향 5대 속성 SOLID 중 이것을 DIP, Dependency Inversion Priciple이라고 한다. 

```swift 
class CouponService: CouponServiceProtocol {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func getClubCouponsAdmin(clubId: Int) async -> DataResponse<GetClubCouponsAdminResponse, NetworkError> {
        
        let url = "\(BASE_URL)/clubs/\(clubId)/coupons/admin"
        let hearders: HTTPHeaders = ["Authorization" : "Bearer \(UserDefaults.standard.string(forKey: JWT_KEY) ?? "")"]
        let response = await AF.request(url, method: .get, encoding: JSONEncoding.default, headers: hearders).serializingDecodable(GetClubCouponsAdminResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
        
    }

    //생략 
}
```

CouponServcie는 이제 CouponServiceProtocol을 conform하고 있다. 또한 url을 이니셜라이저 패러미터로 주입받는데 테스트할 때 이점이 있다. 

기존에는 prodcServer 사용 중에 devServer로 테스트를 할 때마다 직접 코드를 바꿔줘야했지만 이제는 Test 파일에 devServer url을 주입시켜주면 내가 변경해줄 필요가 없다. prodServer 테스트가 필요하면 객체를 2개 생성해서 이용하면 된다. 코드 변경의 귀찮음이 줄어들었다.  

```swift 
class CouponViewModel: ObservableObject, BaseViewModel {
    
    let clubId: Int
    let couponService: CouponServiceProtocol
    
    init(clubId: Int, couponService: CouponServiceProtocol) {
        self.clubId = clubId
        self.couponService = couponService
        Task { await getClubCouponsAdmin() }
    }
    // 생략 
}
```

CouponService를 사용하고 있는 viewModel은 프로토콜 타입으로 주입을 받는다. 의존성을 변경할 수 있다고 했는데 여기서 이점이 생긴다. 

```swift
class MockupCouponService: CouponServiceProtocol {
    func getClubCouponsAdmin(clubId: Int) async -> Alamofire.DataResponse<GetClubCouponsAdminResponse, NetworkError> {

        let result = Result {
            return GetClubCouponsAdminResponse(statusCode: 200, responseMessage: "", data: CouponPreviewData.dummyCouponPreviewDatas())
        }
        .mapError { _ in
            return NetworkError(initialError: nil, serverError: nil)
        }

        return DataResponse(request: .none, response: .none, data: .none, metrics: .none, serializationDuration: 0.0, result: result)

    }

    // 생략 
}
``` 
api 통신 후 데이터를 보여주는 preview는 사실상 무용지물이 되는데 목업데이터를 보내는 서비스를 하나 만들어주어서 해결할 수 있다. CouponViewModel에 CouponService, MockupCouponService 두가지 의존성이 주입 가능해졌다. 

```swift

struct MyCouponView: View {   
    @StateObject var myCouponVM = MyCouponViewModel(couponService: CouponService(url: ServerURL.runningServer.url))
}

struct MyCouponView_Previews: PreviewProvider {
    static var previews: some View {
        MyCouponView(myCouponVM: MockupCouponViewModel())
    }
}
```
실제 뷰에는 통신을 위한 서비스를 넣어주고 프리뷰에는 목업데이터를 보내주는 서비스를 넣어서 프리뷰 이용이 가능해진다. 