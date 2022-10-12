# RTU-iOS-App

# Dependency Injection 
[이곳](https://jacobko.info/swiftui/swiftui-35/)을 참고한 글 
```swift 
 class CouponService {
    static let shared = CouponService()
    private init() { }
    //  생략
}

class DetailCouponViewModel: ObservableObject, BaseViewModel {
    let couponService = CouponService.shard 
    // 생략
}
```

기존에는 api통신을 하기위한 기능들을 service class에서 만들어 싱글톤으로 이용했다. 싱글톤은 배우는 과정에서는 편하지만 몇가지 문제점이 있다. 

1. 싱글톤은 전역으로(GLOBAL) 이용된다.
   
   싱글톤이 사용된 인스턴스는 어디서든 접근이 가능하다. 앱이 커지면 많은 전역 변수가 생겨 혼란스러울 수 있다. 그리고 같은 싱글톤 인스턴스가 멀티 쓰레드 환경에서 이용되고 동시에 접근이 된다면 크래시가 발생될 우려가 있다. 

2. 이시녈라이저를 커스텀할 수 없다. 

    테스트할 때 패러미터를 이용한 초기화는 중요한데 싱글톤을 이용하면 패러미터를 전달할 수 없다. 

   
싱글톤의 문제를 피하기 위해서 의존성 주입(Dependency Injection)을 사용했다.

```swift
protocol CouponServiceProtocol {
    func getClubCouponsAdmin(clubId: Int) async -> DataResponse<GetClubCouponsAdminResponse, NetworkError>
    func getCouponAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponAdminResponse, NetworkError>
    func getCouponMembersAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponMembersAdmin, NetworkError>
    func getCouponMembersHistoriesAdmin(clubId: Int, couponId: Int) async -> DataResponse<GetCouponMembersHistoriesAdmin, NetworkError>
    // 생략 
}
```

작성중 

