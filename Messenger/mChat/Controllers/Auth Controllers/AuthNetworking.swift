//
//  AuthNetworking.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/19/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

class AuthNetworking {
    
    var signInVC: SignInVC!
    
    func signIn(with email: String, and pass: String, completion: @escaping (_ error: Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
            if let error = error {
                return completion(error)
            }else{
                self.nextController(self.signInVC)
            }
        }
    }
    
    func nextController(_ vc: UIViewController){
        let uid = Auth.auth().currentUser?.uid
        Constants.db.reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            guard let snap = snapshot.value as? [String: AnyObject] else { return }
            CurrentUser.name = snap["name"] as? String
            CurrentUser.email = snap["email"] as? String
            CurrentUser.profileImage = snap["profileImage"] as? String
            CurrentUser.uid = uid
            CurrentUser.isMapLocationEnabled = snap["isMapLocationEnabled"] as? Bool
            Constants.activityObservers(isOnline: true)
            let controller = ChatTabBar()
            controller.modalPresentationStyle = .fullScreen
            ChatKit.map.showsUserLocation = true
            ChatKit.startUpdatingUserLocation()
            self.signInVC.show(controller, sender: nil)
        }
    }
    
}
