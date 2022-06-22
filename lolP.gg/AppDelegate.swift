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
        //애플로그인
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        appleIDProvider.getCredentialState(forUserID: "001540.c6835251bfef490db3f9d543bfc71a7a.1133") {
//            (credentialState, error) in
//            switch credentialState {
//            case .authorized:
//
//                print("해당 ID는 연동되어 있습니다.")
//                break
//            case .revoked:
//                print("리보크")
//                break
//            case .notFound:
//                print("해당 ID는 연동되어있지 않습니다.")
//                break
//            default:
//                print("해당 ID를 찾을 수 없습니다.")
//                break
//            }
//        }
        
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

