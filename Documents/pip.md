# 프로토콜 지향 

야곰님이 저술하신 스위프트 프로그래밍의 프로토콜 지향 파트를 읽던 중 이 프로젝트를 개선할만한 내용을 찾게되었다. 책의 뒷부분까지 모두 읽지는 않았지만 내용을 잊기 전에 바로 바로 필요한 내용을 응용하는 스타일이라 추후에 내용이 더 추가될 수도 있다. 참고로, @discadableResult도 책에서 찾고 필요한 부분에 적용하긴 했지만 다룰 내용이 많지는 않아서 별도로 문서에 남겨놓치는 않았다. 

프로토콜에서는 청사진만을 제공하고 중첩문 안의 내용은 작성하지 못한다. 구현부를 작성하기 싫으면 클래스의 상속을 이용하는 방법이 있다. 그런데 스위프트에서 기본적으로 제공하는 타입들은 모두 구조체(struct) 타입들이다. 이들도 모두 프로토콜을 이용하고 있을텐데 그러면 구현부는 각 구조체에서 정의해주고 있을까? 이걸 해결하는 방법이 extension을 활용하는 것이다. 

제너릭, 프로토콜, 익스텐션 세가지를 이용해서 우리는 프로토콜 지향적으로 코드를 작성할 수 있는데 이번에 적용한 내용은 단순하다. 

> extesnsion에서는 구현부를 작성할 수 있다. 

안드로이드를 공부할 떄는 수업 시간에 자바를 꽤나 열심히해서 따로 문법 공부를 안했었는데 이 프로젝트는 내 첫 iOS 프로젝트이고 스위프트에 대한 이해가 전혀 없이 시작해서 저 내용을 이제서야 알았다. 

Ren2U 프로젝트의 뷰모델은 `showAlert(error: )`를 사용하는데 로직은 모두 동일하다. 단순히 프로토콜에서는 구현부를 작성할 수 없다까지만 알고 있어서 이전까지는 코드 스니펫에 구현부를 저장해두고 `BaseViewModel`을 준수하는 뷰모델마다 이 코드를 작성해줬다. 코드 스니펫을 이용해 더 빠르게 할 수는 있었지만, extension을 활용하면 구현부를 작성할 필요조차 없다. 

```swift 
extension BaseViewModel {
    func showAlert(with error: NetworkError) {
        oneButtonAlert.title = "에러"
        oneButtonAlert.messageText = error.serverError == nil ? error.initialError!.localizedDescription : error.serverError!.message
        oneButtonAlert.isPresented = true
    }
} 

``` 

저 부분만 추가해주면 더이상 같은 코드를 반복적으로 작성할 필요도, 코드 스니펫을 활용해줄 필요도 없다. 

# 개선

그런데 네트워크 통신의 결과를 표시해주는 기능만 공통적이지는 않다. 그냥 Alert를 표시해주는 로직은 모두 공통적으로 사용된다. 이번에는 이 기능들을 모두 프로토콜 지향적으로 수정해줄 것이다. 이것이 처

Alert는 현재 두가지 타입을 이용하고 있다. 확인 버튼만 나오는 Alert와 취소, 확인 버튼이 나오는 Alert를 각각 `OneButtonAlert`, `TwoButtonsAlert` 구조체 타입으로 이용하고 있는데 이제는 이것들을 하나로 합쳐줄 것이다. 두개를 이용해도 크게 문제는 없지만 더 깔끔한 코드를 작성하기 위해서다. 

## Alert 변경 

`OneButtonAlert`에 취소 버튼을 보여주는지 확인하는 변수만 추가하면 된다. View단에서 코드를 깔끔하게 나타내기 위해 Text는 미리 computedProperty로 만들어두었다. 

```swift 
struct CustomAlert {
    var titleText: String = ""
    var messageText: String = ""
    var callback: () async -> () = { }
    var isPresentedAlert = false
    var isPresentedCancelButton = false
    
    var message: Text {
        Text(messageText)
    }
    
    static let CancelButton = Button("취소", role: .cancel) { }
}
```

## BaseViewModel 

`showAlert(error: )`처럼 다른 기능들도 프로토콜에 작성하고 extension에 로직을 작성한다. 취소 버튼의 유무에 따라서 두 가지 메소드를 구분해줬다. 취소 버튼까지 보여줄거면 `CustomAlert`의 `isPresentedCancelButton`을 true로 바꿔줄 것이다. 

``` swift
protocol BaseViewModel: ObservableObject {
    var alert: CustomAlert { get set }
    var alertCase: BaseAlert? { get set }
    
    func showAlert(alertCase: BaseAlert)
    func showAlertWithCancelButton(alertCase: BaseAlert)
}

extension BaseViewModel {
    
    @MainActor
    func showAlert(alertCase: BaseAlert) {
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
            print(alert.isPresentedAlert)
        }
    }
    
    @MainActor
    func showAlertWithCancelButton(alertCase: BaseAlert) {
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
``` 

완성된 코드를 사용해서 BaseAlert를 parameter와 property로 사용하는 것이 보인다. 기존에 사용했던 `AlertCase`는 각 뷰모델에서 정의하기 때문에 이를 인자로 넘겨주기 위해서 새로운 프로토콜인 `BaseAlert`가 필요해졌다. 

## BaseAlert 

```swift
protocol BaseAlert {
    var title: String { get }
    var message: String { get }
    var callback: () async -> () { get }
}
``` 

각 AlertCase에게 할당해줄 값을 갖는것이 `BaseAlert`다. 기존에 사용했던대로 title, message, 버튼을 눌렀을 때 실행할 메소드를 값으로 갖는다. 

## ViewModel 

기본적으로 필요한 내용은 모두 프로토콜에 정의했으니 뷰모델에서 해줄 일은 필요한 AlertCase를 만들어주는 일이다. [이곳](https://github.com/paranArena/RTU-iOS-App/blob/develop/Documents/test.md)에서는 서비스를 관련 값으로 사용하기 귀찮아서 다른 방식을 이용한다고 했는데 이제는 관련 값 사용이 불가피하게 되었다. 아래 코드는 예제용으로 서비스 계층이나 관련값을 사용하지는 않았다. 

```swift
class TestViewModel: BaseViewModel {
    @Published var alert: CustomAlert = CustomAlert()
    @Published var alertCase: BaseAlert?
    
    @MainActor func buttonTapped() {
        showAlert(alertCase: AlertCase.ok)
    }
    
    @MainActor func secondButtonTapped() {
        showAlertWithCancelButton(alertCase: AlertCase.cancel)
    }
    
    
    
    enum AlertCase: BaseAlert {
        
        case ok
        case cancel
        
        var title: String {
            switch self {
            case .ok:
                return "OK Title"
            case .cancel:
                return "Cancel Title "
            }
        }
        
        var message: String {
            switch self {
            case .ok:
                return "OK Message"
            case .cancel:
                return "Cancel Message"
            }
        }
        
        var callback: () async -> () {
            switch self {
            case .ok:
                return { print("Callback") }
            case .cancel:
                return { print("Cancel callback")}
            }
        }
        
        
    }
}
``` 

`BaseAlert`는 옵셔널이라 사용하지 않을 곳에서는 굳이 AlertCase를 정의하지 않아도 문제없다. @objc를 활용하는 방안도 있지만 아직까지는 무슨 문제가 있을지 예상이 잘 안돼서 우선은 사용하지 않기로 했다. @objc보단 `BaseViewModel`을 Alert만을 위한 다른 프로토콜 이름으로 명명을 변경해주고, `ObservableObject`를 준수하지 않도록 변경하는 것이 더 나은 방안으로 보인다. 

View단에서는 크게 바뀐점이 없어서 생략한다. 