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
    
    var authNetworking = AuthNetworking()
    var selectedImage: UIImage!
    var profileImage = UIImageView(image: UIImage(named: "DefaultUserImage"))
    var changeImageButton = UIButton(type: .system)
    var continueButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGradientView()
        setupProfileView()
        setupBackButton()
        setupContinueButton()
    }
    
    func setupGradientView() {
        let _ = AuthGradientView(self, true)
    }
    
    func setupProfileView() {
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 75
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
        let constraints = [
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupBackButton() {
        let backButton = AuthBackButton(self)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
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
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
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
        changeImageButton.addTarget(self, action: #selector(changeImagePressed), for: .touchUpInside)
        let constraints = [
            changeImageButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            changeImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeImageButton.heightAnchor.constraint(equalToConstant: 35),
            changeImageButton.widthAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func changeImagePressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Open Photo Library", style: .default, handler: { (alertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func continueButtonPressed(){
        authNetworking.mainController = self
        authNetworking.registerUser(name, email, password, profileImage.image) { (error) in
            self.showAlert(title: "Error", message: error)
        }
    }
    
}
