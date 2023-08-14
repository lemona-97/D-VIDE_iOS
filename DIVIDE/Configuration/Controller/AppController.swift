//
//  AppController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/10.
//

import Foundation
import Firebase
import UIKit
import FirebaseAuth

final class AppController {
    static let shared = AppController()
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    init() {
        FirebaseApp.configure()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSignIn),
                                               name: .AuthStateDidChange,
                                               object: nil)
    }
    
    func show(in window: UIWindow?) {
        guard let window = window else {
            fatalError("Cannot layout app with a nil window.")
        }
        self.window = window
        window.tintColor = .mainOrange1
        window.backgroundColor = .viewBackgroundGray
        checkSignIn()
        window.makeKeyAndVisible()
    }

    @objc private func checkSignIn() {
        if let user = Auth.auth().currentUser {
            setCahnnelScene(with: user)
        }
    }
    
    private func setCahnnelScene(with user: User) {
        let channelVC = ChatListViewController()
        rootViewController = UINavigationController(rootViewController: channelVC)
    }
    
 
}
