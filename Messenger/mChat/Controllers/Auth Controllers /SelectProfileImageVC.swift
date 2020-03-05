//
//  SelectProfileImageVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class SelectProfileImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // SelectProfileImageVC. A final step in a registration process. (If a user chooses not to provide his/her picture, then a default image will be provided.)
    // User credentials
    
    var name: String!
    var email: String!
    var password: String!
    
    var authNetworking: AuthNetworking!
    var selectedImage: UIImage!
    var profileImage = UIImageView(image: UIImage(named: "DefaultUserImage"))
    var continueButton = UIButton(type: .system)
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGradientView()
        setupRegistrationInfoView()
        setupBackButton()
        setupContinueButton()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupGradientView() {
        let _ = GradientLogoView(self, true)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupRegistrationInfoView(){
        let _ = RegistrationInfoView(frame: view.frame, self, profileImage: profileImage)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupContinueButton() {
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.setTitle("CONTINUE", for: .normal)
        continueButton.tintColor = ThemeColors.mainColor
        continueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        let constraints = [
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupBackButton() {
        let backButton = AuthBackButton(self)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: CHANGE IMAGE METHOD
    
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: CONTINUE BUTTON PRESSED METHOD
    
    @objc private func continueButtonPressed(){
        authNetworking = AuthNetworking(self)
        authNetworking.registerUser(name, email, password, profileImage.image) { (error) in
            self.authNetworking.networkingLoadingIndicator.endLoadingAnimation()
            self.showAlert(title: "Error", message: error)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
