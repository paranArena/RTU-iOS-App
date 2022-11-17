

# ImagePickerViewModel 설명 

- [ImagePickerViewModel 설명](#imagepickerviewmodel-설명)
  - [Introduction](#introduction)
  - [alert, confirmationDialog](#alert-confirmationdialog)
  - [how to use in View](#how-to-use-in-view)
  - [ImagePath, UIImage를 따로 사용하는 이유](#imagepath-uiimage를-따로-사용하는-이유)

## Introduction 

![IMG_1B4FBA43A125-1](https://user-images.githubusercontent.com/83946805/202409101-cdc9f1ff-f638-4589-bfc6-3b350c52d608.jpeg)

ImagePickerViewModel은 특정 뷰에서 종속적으로 사용하지 않는다. `EnvironmentObject` 프로퍼리 래퍼를 이용해 이미지를 저장하고 싶은 모든 뷰에서 사용할 수 있다. 주요 기능은  `confirmationDialog`를 불러오는 것이다. 디바이스의 카메라와 앨범을 가져오고, 카메라는 특히 사용 권한을 확인해 `alert`를 표시해주는 기능을 한다. 

## alert, confirmationDialog 

`alert`와 `confirmationDialog`는 `ContentView`에서 선언되어 다른 뷰에서는 modifier를 사용할 필요는 없다. 

## how to use in View

이미지를 사용하고 싶은 뷰에서 `ImagePickerViewModel`을 사용할 때 주의해야 할 점은 별도의 UIImage와 ImagePath, NavigationLink 필요하단 점이다. 

`ImagePickerViewModel`에서 UIImage와 ImagePath를 일괄적으로 처리하면 특정 상황마다 초기화를 시켜줘야하는데 현재 `ImagePickerViewModel`이 사용되는 곳은 세곳이 있다. 특히 물품을 등록할 때는 `onAppear`로 초기화를 해줄 수 없기때문에 어려움이 예상됐다. 

```swift
 Button {
            imagePickerVM.showDialog()
        } label: {
            Image(systemName: "camera")
                .resizable()
                .foregroundColor(.gray_ADB5BD)
                .frame(width: 30, height: 30)
                .padding(.vertical, 20)
        }
        .padding(.horizontal, 20)
        .frame(width: 80, height: 80)
        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray_ADB5BD, lineWidth: 2))
        .sheet(isPresented: $imagePickerVM.isShowingPicker) {
            UpdatedImagePickerView(sourceType: imagePickerVM.source == .library ? .photoLibrary : .camera, selectedImage: $notificationVM.uiImage, imagePath: $notificationVM.notificationParam.imagePath)
                .ignoresSafeArea()
        }
``` 


`ImagePicker`를 뷰 스택에 쌓기 위한 바인딩 값은 `ImagePickerViewModel`에 있는 `isShowingPicker` 변수를 사용하되 변경해주고 싶은 imagePath와 UIImage는 각 뷰가 갖고 있는 값을 사용한다. 

## ImagePath, UIImage를 따로 사용하는 이유

ImagePath는 당연히 사용해야한다. API 스펙에 이미지를 업로드하는데 Image를 보내는게 아니라 `String` 타입으로 된 ImagePath를 보낸다.

그런데 ImagePath만 이용해서 선택한 이미지를 처리하면 이미지를 변경할 때 즉시 화면에 렌더링되지 않는다. 

Image 선택 -> 서버에서 multipart-form data를 이용해 이미지 등록 후 imagePath 반환 -> 반환받은 ImagePath를 이용해서 다시 이미지를 가져옴 

이런 과정을 거치기때문에 이미지를 그리는 속도가 느린 것으로 추정된다. 이미지 선택 후 즉시 화면에 표시하기 위해 UIImage를 사용하고, 서버에 보내기 위해 ImagePath를 사용한다. 







