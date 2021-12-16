//
//  AppDelegate.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/11/17.
//

import UIKit
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
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
    
    //팝업을 만들고 싶다.
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController is LoginPopupViewController {
//            /*
//             let storyboard = UIStoryboard(name: "Popup", bundle: nil)
//             let popupViewController = storyboard.instantiateViewController(withIdentifier: "Popup") as! PopupViewController
//             popupViewController.modalPresentationStyle = .fullScreen
//             tabBarController.present(popupViewController, animated: true, completion: nil)
//             */
//            if let popupView = tabBarController.storyboard?.instantiateViewController(withIdentifier: "popup") {
//                tabBarController.present(popupView, animated: true)
//                return false
//            }
//            return false
//        }
//        return true
//    }


}

