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
    var changeImageButton = UIButton(type: .system)
    var continueButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGradientView()
        setupLogo()
        setupProfileView()
        setupBackButton()
        setupContinueButton()
    }
    
    func setupGradientView() {
        let gradientView = UIView()
        view.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.clipsToBounds = true
        gradientView.layer.cornerRadius = 50
        gradientView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        let constraints = [
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        let gradient = setupGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupLogo() {
        let logoView = UIView()
        view.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.backgroundColor = .white
        logoView.layer.cornerRadius = 50
        logoView.layer.masksToBounds = true
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Logo-Light")
        imageView.layer.cornerRadius = 45
        imageView.layer.masksToBounds = true
        let constraints = [
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/6),
            logoView.widthAnchor.constraint(equalToConstant: 100),
            logoView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupProfileView() {
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 75
        profileImage.layer.masksToBounds = true
        let constraints = [
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(constraints)
    }
        
    func setupBackButton() {
        let backButton = UIButton(type: .system)
        view.addSubview(backButton)
        backButton.setBackgroundImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.layer.masksToBounds = true
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let constraints = [
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
        ]
        NSLayoutConstraint.activate(constraints)
    }
        
    func setupGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let topColor = UIColor(red: 100/255, green: 90/255, blue: 255/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 140/255, green: 135/255, blue: 255/255, alpha: 1).cgColor
        gradient.colors = [topColor, bottomColor]
        gradient.locations = [0, 1]
        return gradient
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupContinueButton() {
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.setTitle("CONTINUE", for: .normal)
        continueButton.tintColor = AppColors.mainColor
        continueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        let constraints = [
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)
        setupInfoLabels()
    }

    func setupInfoLabels() {
        let nameLabel = UILabel()
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = name.uppercased()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        let emailLabel = UILabel()
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = email.uppercased()
        emailLabel.font = UIFont.boldSystemFont(ofSize: 12)
        emailLabel.textColor = .lightGray
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        setupChangeImageButton(emailLabel)
    }
    
    func setupChangeImageButton(_ emailLabel: UILabel) {
        view.addSubview(changeImageButton)
        changeImageButton.frame = CGRect(x: 0, y: 0, width: 200, height: 35)
        changeImageButton.translatesAutoresizingMaskIntoConstraints = false
        changeImageButton.layer.cornerRadius = 8
        changeImageButton.setTitle("CHANGE PROFILE IMAGE", for: .normal)
        changeImageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        changeImageButton.layer.masksToBounds = true
        changeImageButton.tintColor = .white
        let gradient = setupGradientLayer()
        gradient.frame = changeImageButton.frame
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        changeImageButton.layer.insertSublayer(gradient, at: 0)
        let constraints = [
            changeImageButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            changeImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeImageButton.heightAnchor.constraint(equalToConstant: 35),
            changeImageButton.widthAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    //    func setupButtons() {
    //        view.addSubview(selectImageButton)
    //        view.addSubview(continueButton)
    //        setupButton(selectImageButton, "Select Image")
    //        setupButton(continueButton, "Continue")
    //        selectImageButton.addTarget(self, action: #selector(selectImageButtonPressed), for: .touchUpInside)
    //        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
    //        NSLayoutConstraint.activate(configureButtonsConstraints(selectImageButton, profileImage, 150, 40, 150))
    //        NSLayoutConstraint.activate(configureButtonsConstraints(continueButton, selectImageButton, 50, 40, 150))
    //    }
    //
    //    func setupProfileImage(){
    //        view.addSubview(profileImage)
    //        setupImages(profileImage, .scaleAspectFill, 50, true)
    //        NSLayoutConstraint.activate(configureImagesConstraints(profileImage, 100, 100, view, 150))
    //    }
    //
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
    //            selectedImage = editedImage
    //        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
    //            selectedImage = originalImage
    //        }
    //        if let userImage = selectedImage {
    //            profileImage.image = userImage
    //        }
    //        dismiss(animated: true, completion: nil)
    //    }
    //
    //    func openImagePicker(_ type: UIImagePickerController.SourceType) {
    //        let picker = UIImagePickerController()
    //        picker.delegate = self
    //        picker.sourceType = type
    //        picker.allowsEditing = true
    //        present(picker, animated: true, completion: nil)
    //    }
    //
    //    @objc func selectImageButtonPressed(){
    //        openImagePicker(.photoLibrary)
    //    }
    //
    //    @objc func continueButtonPressed(){
    //        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
    //            if let error = error {
    //                self.showAlert(title: "Error", message: error.localizedDescription)
    //                return
    //            }
    //            guard let uid = dataResult?.user.uid else { return }
    //            if self.selectedImage == nil {
    //                self.selectedImage = UIImage(named: "DefaultUserImage")
    //            }
    //            let uniqueName = NSUUID().uuidString
    //            let storageRef = Storage.storage().reference().child("ProfileImages").child("\(uniqueName).jpg")
    //            if let uploadData = self.selectedImage.jpegData(compressionQuality: 0.1) {
    //                storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
    //                    if let error = error {
    //                        self.showAlert(title: "Error", message: error.localizedDescription)
    //                        return
    //                    }
    //                    storageRef.downloadURL { (url, error) in
    //                        if let error = error {
    //                            print(error.localizedDescription)
    //                            return
    //                        }
    //                        guard let url = url else {
    //                            print("Error downloading image(url is nil)")
    //                            return
    //                        }
    //                        let values: [String: Any] = ["name": self.name!, "email": self.email!, "profileImage": url.absoluteString, "isMapLocationEnabled": false]
    //                        self.registerUserHandler(uid,values)
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    //    func registerUserHandler(_ uid: String, _ values: [String : Any]){
    //        let usersRef = Constants.db.reference().child("users").child(uid)
    //        usersRef.updateChildValues(values) { (error, dataRef) in
    //            if let error = error {
    //                self.showAlert(title: "Error", message: error.localizedDescription)
    //                return
    //            }
    //            print("User was successfuly saved into Firebase DB")
    //            self.nextController()
    //        }
    //    }
    //
    //    func nextController(){
    //        let uid = Auth.auth().currentUser?.uid
    //        Constants.db.reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
    //            guard let snap = snapshot.value as? [String: AnyObject] else { return }
    //            CurrentUser.name = snap["name"] as? String
    //            CurrentUser.email = snap["email"] as? String
    //            CurrentUser.profileImage = snap["profileImage"] as? String
    //            CurrentUser.uid = uid
    //            CurrentUser.isMapLocationEnabled = snap["isMapLocationEnabled"] as? Bool
    //            Constants.activityObservers(isOnline: true)
    //            ChatKit.startUpdatingUserLocation()
    //            let controller = ChatTabBar()
    //            controller.modalPresentationStyle = .fullScreen
    //            self.show(controller, sender: nil)
    //        }
    //    }
    
}
