# Content 

- [Content](#content)
- [Dependency Injection](#dependency-injection)
- [재사용](#재사용)
  - [UI](#ui)
  - [Service](#service)

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

# 재사용

## UI 

디자인이 완성되고 개발을 시작한 것이 아니라 그때 그때 하나의 뷰가 완성되면 하나씩 개발을 시작했다. 처음에는 재사용을 고려했으나 이를 포기한 이유는 두가지가 있다. 

1. 디자인이 나올 때마다 사용하는 컴포넌트가 많이 달라졌다. 디자인측에서도 재사용성이 부족했다.  재사용하지 않을 뷰의 경우에는 해당 소스 파일에 작성했는데 이걸 구분하기가 어려웠다. 점점 재사용을 고려하지 않게 되었다.
2. 체계적인 명명방법을 정하지 않았다. 어떤 컴포넌트 하나를 찾기 위해서 직관적으로 머리에 떠오르는 단어가 없었다. 컴포넌트를 모아놓은 파일을 보고 찾아봐야했다. 

이후 계획에 없던 기능이 추가되면서 뷰가 꽤 재사용되기 시작했다. 그러나 각각 다른 뷰기 때문에 수정할 때는 많은 어려움이 있을게 예상됐다. 차라리 모든 뷰를 재사용을 고려해서 만들고, 명명 방법을 정하고 시작해야했다. 

## Service 

현재 아키텍처에서 백엔드 API를 사용하는 곳을 `Service`로 분리했다. 뷰모델이 어차피 뷰에 종속되어서 거의 재활용이 안되는 것처럼 API 역시 마찬가지였다. 그런데 테스트 코드를 작성하던 중 이런 재사용성에서 문제가 있는 부분을 발견했다. 

```swift
func login(param: [String : Any]) async -> Alamofire.DataResponse<LoginResponse, NetworkError> {
        let url = "\(url!)/authenticate"
        
        let response = await AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).serializingDecodable(LoginResponse.self).response
        
        return response.mapError { err in
            let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0) }
            return NetworkError(initialError: err, serverError: serverError)
        }
    }
``` 

만약 로그인 기능을 여러 뷰모델에서 사용하고 있다면 어떤 문제가 있을까? 사용하고 있는 parameter에 변경이 생기면 양쪽 view model에서 패러미터로 사용하고 있는 Dictionary 타입인 `param`을 모두 변경해줘야 한다. 


```json 
{
    "email": "{{email}}",
    "password": "{{password}}"
}
```

현재 서버에서는 로그인을 위해 저런 형식으로 BODY를 보내주고 있다. 

```json 
{
    "ajouEmail": "{{email}}",
    "password": "{{password}}"
}
```

이런식으로 변경이 생겼다면 사용하고있는 뷰모델에서 모두 저렇게 변경을 해줘야한다. 그래서 데이터를 가공해야 하면 사용하는 측에서 가공을 하는게 낫다는 생각이 들었다. 찾아보면 무슨 법칙이나 원칙같은게 있을거 같은데 지식이 얕아 그런것까지느 아직 모르겠다. 

```swift
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
``` 

수정 후, Dictionary에 사용될 데이터들을 가공없이 그대로 보내주고 서비스 코드 내에서 데이터를 변환해서 사용하고 있다. 이제 API에 변경이 생겨도 여러 곳을 수정할 필요가 없어졌다.