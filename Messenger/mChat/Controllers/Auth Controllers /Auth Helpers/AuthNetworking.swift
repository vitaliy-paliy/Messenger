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
    
    var mainController: UIViewController!
    
    var networkingLoadingIndicator = NetworkingLoadingIndicator()
    
    init(_ mainController: UIViewController?){
        self.mainController = mainController
    }
    
    
    func signIn(with email: String, and pass: String, completion: @escaping (_ error: Error?) -> Void){
        networkingLoadingIndicator.startLoadingAnimation()
        Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
            if let error = error {
                self.networkingLoadingIndicator.endLoadingAnimation()
                return completion(error)
            }else{
                self.nextController()
            }
        }
    }
    
    func nextController(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        setupUserInfo(uid) {
            let controller = ChatTabBar()
            controller.modalPresentationStyle = .fullScreen
            self.mainController.present(controller, animated: false, completion: nil)
            self.networkingLoadingIndicator.endLoadingAnimation()
        }
    }
    
    func setupUserInfo(_ uid: String, completion: @escaping () -> Void) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let snap = snapshot.value as? [String: AnyObject] else { return }
            CurrentUser.name = snap["name"] as? String
            CurrentUser.email = snap["email"] as? String
            CurrentUser.profileImage = snap["profileImage"] as? String
            CurrentUser.uid = uid
            CurrentUser.isMapLocationEnabled = snap["isMapLocationEnabled"] as? Bool
            Constants.activityObservers(isOnline: true)
            if CurrentUser.isMapLocationEnabled {
                ChatKit.map.showsUserLocation = true
                ChatKit.startUpdatingUserLocation()
            }
            return completion()
        }
    }
    
    func checkForExistingEmail(_ email: String, completion: @escaping (_ errorMessage: String?) -> Void) {
        networkingLoadingIndicator.startLoadingAnimation()
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            self.networkingLoadingIndicator.endLoadingAnimation()
            if methods == nil {
                return completion(nil)
            }else{
                return completion("This email is already in use.")
            }
        }
    }
    
    func registerUser(_ name: String, _ email: String, _ password: String, _ profileImage: UIImage?, completion: @escaping (_ error: String?) -> Void) {
        networkingLoadingIndicator.startLoadingAnimation()
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
            if let error = error { return completion(error.localizedDescription) }
            guard let uid = dataResult?.user.uid else { return completion("Error occured, try again!") }
            let imageToSend = profileImage ?? UIImage(named: "DefaultUserImage")
            self.uploadProfileImageToStorage(imageToSend!) { (url, error) in
                if let error = error { return completion(error.localizedDescription) }
                guard let url = url else { return }
                let values: [String: Any] = ["name": name, "email": email, "profileImage": url.absoluteString, "isMapLocationEnabled": false]
                self.registerUserHandler(uid, values) { (error) in
                    if let error = error { return completion(error.localizedDescription) }
                }
            }
        }
    }
    
    private func uploadProfileImageToStorage(_ image: UIImage, completion: @escaping (_ imageUrl: URL?, _ error: Error?) -> Void) {
        let uniqueName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("ProfileImages").child("\(uniqueName).jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.1) {
            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                if let error = error { return completion(nil, error) }
                storageRef.downloadURL { (url, error) in
                    if let error = error { return completion(nil, error) }
                    if let url = url { return completion(url, nil) }
                }
            }
        }
    }
    
    private func registerUserHandler(_ uid: String, _ values: [String:Any], completion: @escaping (_ error: Error?) -> Void) {
        let usersRef = Constants.db.reference().child("users").child(uid)
        usersRef.updateChildValues(values) { (error, dataRef) in
            if let error = error { return completion(error) }
            print("User was successfuly saved into Firebase DB")
            self.nextController()
        }
    }
    
}
