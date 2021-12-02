//
//  AppDelegate.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/11/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        타이틀 Color 모든 컨트롤러에 동일하게 적용하고 싶으면 앱델리게이트에 작성.
//        let myColor = UIColor.tintColor
//        let barAppearance = UINavigationBarAppearance()
//        barAppearance.backgroundColor = myColor
//
//        let navigationBar = UINavigationBar.appearance()
//        navigationBar.standardAppearance = barAppearance
//        navigationBar.scrollEdgeAppearance = barAppearance
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

    
    

}

