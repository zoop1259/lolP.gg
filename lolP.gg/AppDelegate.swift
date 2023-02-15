//
//  AppDelegate.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/11/17.
//

import UIKit
import Firebase
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //파베에서 제공하는 GoogleService-Info에 클라이언트ID가 있기 때문에 주석처리
        // GIDSignIn.sharedInstance().clientID = "client id"
        FirebaseApp.configure()
        //구글 로그인이 제대로 되었는지 확인하기.
        if let user = Auth.auth().currentUser {
            print("당신의 \(user.uid), email: \(user.email ?? "no email")")
        }
        
      //원격 알림 등록.
      //https://firebase.google.com/docs/cloud-messaging/ios/client?hl=ko
      UNUserNotificationCenter.current().delegate = self

      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )

      //메세지 델리게이트 설정
      Messaging.messaging().delegate = self
      
      //앱이 열렸을때도 푸시받을수있게(푸시 포그라운드설정)
      UNUserNotificationCenter.current().delegate = self
      
      application.registerForRemoteNotifications()
      
        //네비게이션 바 색변경.
        let standard = UINavigationBarAppearance()
        standard.configureWithOpaqueBackground()
        standard.backgroundColor = .link
        //standard.titlePositionAdjustment = UIOffset(horizontal: -30, vertical: 0)
        standard.titleTextAttributes = [.foregroundColor: UIColor.white]
        //좌측버튼
        let button = UIBarButtonItemAppearance(style: .plain)
        button.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        standard.buttonAppearance = button
        //우측버튼
        let done = UIBarButtonItemAppearance(style: .done)
        done.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        standard.doneButtonAppearance = done
        //화살표 색
        let arrow = UINavigationBar.appearance()
        arrow.tintColor = .white
        
        //이걸 쓰지않으면 스와이프시 반투명색(흰색)이 된다.
        UINavigationBar.appearance().standardAppearance = standard
        //xcode업데이트 후 이것을 설정해주지않으면 네비게이션바가 반투명색이 된다...
        UINavigationBar.appearance().scrollEdgeAppearance = standard
        
        return true
    }
  
  //apnstoken 속성 설정 (fcm 토큰이 등록되었을때 서로 연결해주는?(파베토큰과 애플토큰을))
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
  

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

extension AppDelegate: MessagingDelegate {
  //fcm 등록 토큰을 받았을 때
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("AppDelegate - 파베 토큰을 받았다.")
    print("AppDelegate - 등록된 토큰은: \(String(describing: fcmToken))")
  }
}

//
extension AppDelegate: UNUserNotificationCenterDelegate {
  
  //푸시 메세지가 앱이 켜진상태로 받을 때
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    //푸쉬로 들어온 데이터가 노티로 들어옴.
    let userInfo = notification.request.content.userInfo
    //유저 정보 print
    print("willPresent userInfo: ", userInfo)
    
    //푸쉬 스타일 설정
    completionHandler([.banner, .sound, .badge])
  }
  
  //푸시 메세지를 받았을 때
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    print("didReceive userInfo: ", userInfo)
    completionHandler()
  }
  
}
