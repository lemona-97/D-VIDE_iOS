//
//  SceneDelegate.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/06/28.
//

import UIKit
import KakaoSDKAuth
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        var initialViewController = UINavigationController()

        getUserLocation()
        
        if AuthApi.hasToken() == false && UserDefaultsManager.DIVIDE_TOKEN == nil {
            print("========================================================")
            print("                 비 로그인 상태")
            print("========================================================")
            initialViewController = UINavigationController(rootViewController: LoginViewController())
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()

        } else if AuthApi.hasToken() {
            print("========================================================")
            print("                 Kakao  - 로그인 상태")
            print("========================================================")
            
            initialViewController = UINavigationController(rootViewController: TabBarController())
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
            
        } else if UserDefaultsManager.DIVIDE_TOKEN != nil {
            print("========================================================")
            print("                 DIVIDE - 자체 로그인 상태 (apple 포함)")
            print("========================================================")
            initialViewController = UINavigationController(rootViewController: TabBarController())
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
      }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func getUserLocation() {
        let locationManager = CLLocationManager()
        // 델리게이트를 설정하고,
        locationManager.delegate = self
        // 거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 사용 허용 알림
        locationManager.requestWhenInUseAuthorization()
        // 위치 사용을 허용하면 현재 위치 정보를 가져옴
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
                print("위치 정보 가져오기")
            }
            else {
                print("위치 서비스 허용 off")
            }
        }
        
    }
}

