//
//  SelectProfileImageVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class SelectProfileImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // User credentials
    var name: String!
    var email: String!
    var password: String!
    var selectedImage: UIImage!
    var profileImage = UIImageView(image: UIImage(named: "DefaultUserImage"))
    var selectImageButton = UIButton(type: .system)
    var continueButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProfileImage()
        setupButtons()
    }
 
    func setupButtons() {
        view.addSubview(selectImageButton)
        view.addSubview(continueButton)
        setupButton(selectImageButton, "Select Image")
        setupButton(continueButton, "Continue")
        selectImageButton.addTarget(self, action: #selector(selectImageButtonPressed), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate(configureButtonsConstraints(selectImageButton, profileImage, 150, 40, 150))
        NSLayoutConstraint.activate(configureButtonsConstraints(continueButton, selectImageButton, 50, 40, 150))
    }
    
    func setupProfileImage(){
        view.addSubview(profileImage)
        setupImages(profileImage, .scaleAspectFill, 50, true)
        NSLayoutConstraint.activate(configureImagesConstraints(profileImage, 100, 100, view, 150))
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        if let userImage = selectedImage {
            profileImage.image = userImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func openImagePicker(_ type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc func selectImageButtonPressed(){
        openImagePicker(.photoLibrary)
    }
    
    @objc func continueButtonPressed(){
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            guard let uid = dataResult?.user.uid else { return }
            if self.selectedImage == nil {
                self.selectedImage = UIImage(named: "DefaultUserImage")
            }
            let uniqueName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("ProfileImages").child("\(uniqueName).jpg")
            if let uploadData = self.selectedImage.jpegData(compressionQuality: 0.1) {
                storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        guard let url = url else {
                            print("Error downloading image(url is nil)")
                            return
                        }
                        let values: [String: Any] = ["name": self.name!, "email": self.email!, "profileImage": url.absoluteString, "isMapLocationEnabled": false]
                        self.registerUserHandler(uid,values)
                    }
                }
            }
        }
    }
    
    func registerUserHandler(_ uid: String, _ values: [String : Any]){
        let usersRef = Constants.db.reference().child("users").child(uid)
        usersRef.updateChildValues(values) { (error, dataRef) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            print("User was successfuly saved into Firebase DB")
            self.nextController()
        }
    }
    
    func nextController(){
        let uid = Auth.auth().currentUser?.uid
        Constants.db.reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            guard let snap = snapshot.value as? [String: AnyObject] else { return }
            CurrentUser.name = snap["name"] as? String
            CurrentUser.email = snap["email"] as? String
            CurrentUser.profileImage = snap["profileImage"] as? String
            CurrentUser.uid = uid
            CurrentUser.isMapLocationEnabled = snap["isMapLocationEnabled"] as? Bool
            Constants.activityObservers(isOnline: true)
            let mapsVC = MapsVC()
            mapsVC.mapView.showsUserLocation = true
            mapsVC.startUpdatingUserLocation()
            let controller = ChatTabBar()
            controller.modalPresentationStyle = .fullScreen
            self.show(controller, sender: nil)
        }
    }
    
}
