# 뷰모델 테스트 

## Alert 

![IMG_1385](https://user-images.githubusercontent.com/83946805/198959817-7e95598e-fb38-4eca-b2be-222217f50d2a.PNG)

위 이미지는 우측 상단의 완료 버튼을 누른 후의 결과다. 뷰모델에서 `compleButtonTapped`라는 이름으로 완료 버튼을 눌렀을 때의 함수를 구현했다. 그런데 테스트를 하기 적절한 코드가 아니었고 개선이 필요했다. 

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
}
```

이제 alert가 특정 input에 따라 어떻게 바뀌는지 테스트 할 수 있다. 