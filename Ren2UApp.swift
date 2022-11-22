//
//  Ren2UApp.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI
import Firebase
import FirebaseMessaging

@main
struct Ren2UApp: App {
    
    @StateObject var myPageVM = MyPageViewModel(fcmService: FCMService(url: ServerURL.runningServer.url))
    @StateObject var groupModel = ClubViewModel()
    @StateObject var tabVM = AmongTabsViewModel()
    @StateObject var locationManager = LocationManager()
    @StateObject var imagePickerVM = ImagePickerViewModel(imageService: ImageService(url: ServerURL.runningServer.url))
    
    // 푸시
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // 네비게이션 바 틴트 컬러 변경 
        Theme.navigationBarColors(tintColor: .label)
        
        // 폰트 이름 출력
//        FontName.printPontNames()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(myPageVM)
                .environmentObject(groupModel)
                .environmentObject(tabVM)
                .environmentObject(locationManager)
                .environmentObject(imagePickerVM)
        }
    }
}

//  MARK: App push

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // 앱이 켜졌을 때
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
    
    // fcm 등록 토큰을 받았을 때. 디바이스 토큰 출력
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaults.standard.set(fcmToken, forKey: FCM_TOKEN)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // push message가 foreground 상태에서 보내질 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        completionHandler([.banner, .sound, .badge])
    }
    
    // push message를 background 상태에서 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        completionHandler()
    }
}
