//
//  SceneDelegate.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let sceneWindow = (scene as? UIWindowScene) else { return }
        FirebaseApp.configure()
        window = UIWindow(windowScene: sceneWindow)
        window?.rootViewController = SignInVC()
        window?.makeKeyAndVisible()
    }

}

