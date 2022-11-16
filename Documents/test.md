# 뷰모델 테스트 

## Alert 

![IMG_1385](https://user-images.githubusercontent.com/83946805/198959817-7e95598e-fb38-4eca-b2be-222217f50d2a.PNG)

위 이미지는 우측 상단의 완료 버튼을 누른 후의 결과다. 뷰모델에서 `compleButtonTapped`라는 이름으로 완료 버튼을 눌렀을 때의 함수를 구현했다. 첫 배포와 다음 두번의 업데이트까지 시간이 촉박했기때문에 테스트를 전혀하지 않아서 여유가 생기고서 바로 테스트를 하려고 했다. 그런데 기존의 코드에서는 테스트할 방법이 보이지 않아 리팩토링을 하기로 하였다. 

우선 기존의 코드를 먼저 살펴보자. 

```swift 
class ClubProfileViewModel: BaseViewModel {
    @Published var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    @Published var clubProfileParam = ClubProfileParam()
    private let clubProfileService: ClubProfileServiceEnable

    init(clubService: ClubProfileServiceEnable) {
        self.clubProfileService = clubService
    }

    @MainActor
    internal func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }

    @MainActor
    func completeButtonTapped(closure: @escaping () -> ()) async {
        if self.clubProfileParam.isCreatable {
            let response = await clubProfileService.createClub(data: self.clubProfileParam)
            if let error = response.error {
                self.showAlert(with: error)
            } else {
                closure() 
            }
        } else {
            oneButtonAlert.title = "그룹 생성 불가" 
            oneButtonAlert.messageText = "그룹 이름, 소개글은 필수입니다." 
            oneButtonAlert.isPresented = true 
        }
    }
}

``` 

`clubProfileParam`의 computedProperty인 `isCreatable`이 false면 oneButtonAlert를 변경해주고 있다. 이 상태에서 결과를 확인하기 위해서는 oneButtonAlert의 title이나 meesageText가 원하는 값인지 확인하는 방법이 있을 것이다.  하지만 messageText / title이 중복되는 경우가 있으면 적절한 테스트가 불가능하다고 생각했다. 그래서 enum을 사용해서 alert를 보여주기 위한 케이스를 정의하기로 했다. 각 케이스마다 title과 message를 computedProperty로 정의하면 alert를 변경하기도 쉬울 것이다. 

```swift 

enum AlertCase {
    case lackOfInformation

    var title: String {
        switch self {
        case .lackOfInformation:
            return "그룹 생성 불가"
        }
    }
    
    var message: String {
        switch self {
            
        case .lackOfInformation:
            return "그룹명과 소개는 필수입니다."
        }
    }
}

``` 
케이스를 정의하고 switch를 통해 title과 message를 만들어주었다. enum + computedProperty를 이용하는 것은 프로젝트에서 많이 활용한 방식이다. 

액션에 따라 alert가 필요한 모든 경우 `AlertCase`에 케이스를 추가하면 쉽게 확장할 수 있다. State를 정의해줬으니 변수를 새로 선언해서 케이스를 만들어준 후, 각 기능이 동작하고 State가 변경되었는지 확인하면 된다. 

> State가 적절한 표현인지 모르겠다. 여러 아키텍처 패턴을 찾아본 결과 struct, enum을 표현하기 위해 State라는 말을 많이 쓰는 것을 보았다. 

```swift 
class ClubProfileViewModel: BaseViewModel {

    @Published var oneButtonAlert: OneButtonAlert = OneButtonAlert()
    @Published var clubProfileParam = ClubProfileParam()
    var alertCase: AlertCase?
    
    private let clubProfileService: ClubProfileServiceEnable
    
    enum AlertCase {
        case lackOfInformation

        var title: String {
            switch self {
            case .lackOfInformation:
                return "그룹 생성 불가"
            }
        }
        
        var message: String {
            switch self {
                
            case .lackOfInformation:
                return "그룹명과 소개는 필수입니다."
            }
        }
    }

    init(clubService: ClubProfileServiceEnable) {
        self.clubProfileService = clubService
    }

    @MainActor
    internal func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
    
    @MainActor
    private func showAlert(selectedCase: AlertCase) {
        alertCase = selectedCase
        if let alertCase = self.alertCase {
            oneButtonAlert.title = alertCase.title
            oneButtonAlert.messageText = alertCase.message
            oneButtonAlert.isPresented = true
            oneButtonAlert.callback = { self.alertCase = nil }
        }
    }
    
    @MainActor
    func completeButtonTapped(closure: @escaping () -> ()) async {
        if self.clubProfileParam.isCreatable {
            let response = await clubProfileService.createClub(data: self.clubProfileParam)
            if let error = response.error {
                self.showAlert(with: error)
            } else {
                closure()
            }
        } else {
            showAlert(selectedCase: .lackOfInformation)
        }
    }
``` 

`showAlert(selectedCase:)`에서 값을 변경해주고 있으니 이제 input 값에 따라 output 값이 정상적으로 변경되는지 확인하면 된다. 

```swift
final class ClubProfileViewModelTests: XCTestCase {
    
    var vm: ClubProfileViewModel!

    override func setUpWithError() throws {
        vm = ClubProfileViewModel(clubService: ClubProfileService(url: ServerURL.devServer.url))
    }

    override func tearDownWithError() throws {
        vm = nil
    }
    
    @MainActor
    func testCompleteButtonTappedWhenClubNameIsEmpty() async {
        vm.clubProfileParam.introduction = "그룹 소개"
        await vm.completeButtonTapped { }
        
        let actual = vm.alertCase
        let expected = ClubProfileViewModel.AlertCase.lackOfInformation
        XCTAssertEqual(actual, expected)
    }

    @MainActor
    func testCompleteButtonTappedWhenCreatable() async {
        vm.clubProfileParam.name = "그룹명"
        vm.clubProfileParam.introduction = "그룹 소개"
        await vm.completeButtonTapped { }
        
        let actual = vm.alertCase
        XCTAssertNil(actual)
    
}
```

이제 alert가 특정 input에 따라 어떻게 바뀌는지 테스트 할 수 있다. 

### 개선 

위 방식으로 `AlertCase`를 이용했을 때 Alert에 콜백을 주기 어려운 경우를 만났다. 버튼을 탭했을 때 사용할 함수를 `AlertCase` 내부의 ComputedProperty에서 정의한다면 상관없었지만 API 통신이 필요한 경우는 사용할 수 없다. 

리팩토링 중에 이런 문제를 찾았고 해당 뷰모델을 예제로 사용하겠다. 

```swift 

class RentViewModel: BaseViewModel {
    let rentService: RentServiceEnable 
    enum AlertCase { 
        case applyAttempt 

        var callback: () -> () {
            switch self {
                case .applyAttempt:
                return rentService.function() 
            }
        }
    }
}
```

이렇게 사용하고 싶었지만 `AlertCase` 내부에서 `rentService`에 접근할 수 없었다. 

> Instance member 'rentService' of type 'RentViewModel' cannot be used on instance of nested type 'RentViewModel.AlertCase'

이런 식으로 경고 문구가 나와서 약간의 수정이 필요해졌는데 단순히 사용할 text, message, callback을 `AlertCase`의 ComputedProperty가 아니라 `RentViewModel`의 ComputedProperty로 변경해주었다.

```swift
extension RentViewModel {
    var alertCase: AlertCase = .rentAttempt 

    enum AlertCase { 
        // ...
    }

    var title: String {
        switch alertCase {
            // ...
        }
    }

    var message: String {
        switch alertCase {
            // ...
        }
    }

    var callback: () -> () {
        switch alertCase {
            // ...
        }
    }
}
``` 

경고 문구 없이 사용할수 있게됐다. 이 방법 외에도 `Service`를 parameter로 각 case에 전달하는 방법도 있었는데 무엇이 더 나은 방법인지는 모르겠다. callback의 대부분이 service가 필요해서 후자의 방법을 사용할 경우 모든 case에 parameter를 전달해야해서 귀찮음이 생긴다. 

```swift 
extension RentViewModel {
    enum AlertCase {
        case rentAttemp(rentService: RentServiceEnable)
    }
}

``` 

위 코드가 두번째 방법이다. parameter 전달을 귀찮아지지만 text, message, callback을 `AlertCase` 내부에서 사용할 수 있게된다. 