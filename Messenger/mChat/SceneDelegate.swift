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
        if Auth.auth().currentUser != nil{
            print("signedIn")
           let uid = Auth.auth().currentUser?.uid
            Constants.db.reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
                guard let snap = snapshot.value as? [String: AnyObject] else { return }
                CurrentUser.name = snap["name"] as? String
                CurrentUser.email = snap["email"] as? String
                CurrentUser.profileImage = snap["profileImage"] as? String
                CurrentUser.uid = uid
                CurrentUser.isMapLocationEnabled = snap["isMapLocationEnabled"] as? Bool
                self.window?.rootViewController = ChatTabBar()
                self.window?.makeKeyAndVisible()
            }
            
        }else{
            window?.rootViewController = SignInVC()
            window?.makeKeyAndVisible()
        }
        activityObservers()
    }
    
    func activityObservers(){
        guard let user = Auth.auth().currentUser else { return }
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(user.uid)
        userRef.child("isOnline").setValue(true)
        userRef.child("isOnline").onDisconnectSetValue(false)
        userRef.child("lastLogin").setValue(Date().timeIntervalSince1970)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        Constants.activityObservers(isOnline: true)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        Constants.activityObservers(isOnline: false)
    }
    
}

