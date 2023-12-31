//
//  AppDelegate.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/06/28.
//

import UIKit
import NMapsMap
import KakaoSDKCommon
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NMFAuthManager.shared().clientId = naverMapClientID
        KakaoSDK.initSDK(appKey: KAKAO_APP_KEY)
        FirebaseApp.configure()
        if let email = UserDefaultsManager.FirebaseEmail, let password = UserDefaultsManager.FirebasePassword {
            Auth.auth().signIn(withEmail: email, password: password)
            print("AppDelegate - 파이어베이스 로그인 ")
        }
//        Thread.sleep(forTimeInterval: 2.0)
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

