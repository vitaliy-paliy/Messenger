//
//  ChangePasswordVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/27/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class ChangePasswordVC: UIViewController{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var infoAnimView = AnimationView()
    var infoLabel = UILabel()
    
    let oldPasswordTF = UITextField()
    let newPasswordTF = UITextField()
    let confirmNewPasswordTF = UITextField()
    let changeButton = UIButton(type: .system)
    let currentUserNetworking = CurrentUserNetworking()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserNetworking.changePasswordVC = self
        setupUI()
        hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Change Password"
        setupInfoLabel()
        setupChangeInfoAnim()
        setupOldPasswordTF()
        setupChangeButton()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupChangeInfoAnim() {
        view.addSubview(infoAnimView)
        infoAnimView.translatesAutoresizingMaskIntoConstraints = false
        infoAnimView.animation = Animation.named("changeInfo_anim")
        infoAnimView.loopMode = .loop
        infoAnimView.play()
        infoAnimView.backgroundBehavior = .pauseAndRestore
        let constraints = [
            infoAnimView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoAnimView.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -16),
            infoAnimView.widthAnchor.constraint(equalToConstant: 250),
            infoAnimView.heightAnchor.constraint(equalToConstant: 250),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupInfoLabel() {
        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.text = "Here you can change your password.\nNOTE: \nA valid password must contain at least 6 characters."
        infoLabel.textColor = .gray
        infoLabel.font = UIFont.boldSystemFont(ofSize: 14)
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        let constraints = [
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupOldPasswordTF() {
        view.addSubview(oldPasswordTF)
        oldPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        setupTF(oldPasswordTF)
        oldPasswordTF.placeholder = "Old Password"
        let constraints = [
            oldPasswordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oldPasswordTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            oldPasswordTF.widthAnchor.constraint(equalToConstant: 250),
            oldPasswordTF.heightAnchor.constraint(equalToConstant: 35)
        ]
        NSLayoutConstraint.activate(constraints)
        setupNewPasswordTF()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNewPasswordTF() {
        view.addSubview(newPasswordTF)
        newPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        setupTF(newPasswordTF)
        newPasswordTF.placeholder = "New Password"
        let constraints = [
            newPasswordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newPasswordTF.topAnchor.constraint(equalTo: oldPasswordTF.bottomAnchor, constant: 8),
            newPasswordTF.widthAnchor.constraint(equalToConstant: 250),
            newPasswordTF.heightAnchor.constraint(equalToConstant: 35),
        ]
        NSLayoutConstraint.activate(constraints)
        setupConfirmTF()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupConfirmTF() {
        view.addSubview(confirmNewPasswordTF)
        confirmNewPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        setupTF(confirmNewPasswordTF)
        confirmNewPasswordTF.placeholder = "Confirm New Password"
        let constraints = [
            confirmNewPasswordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmNewPasswordTF.topAnchor.constraint(equalTo: newPasswordTF.bottomAnchor, constant: 8),
            confirmNewPasswordTF.widthAnchor.constraint(equalToConstant: 250),
            confirmNewPasswordTF.heightAnchor.constraint(equalToConstant: 35),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTF(_ textfield: UITextField) {
        textfield.borderStyle = .none
        textfield.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textfield.layer.cornerRadius = 16
        textfield.layer.masksToBounds = true
        textfield.isSecureTextEntry = true
        textfield.autocapitalizationType = .none
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupChangeButton() {
        view.addSubview(changeButton)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        let gradient = setupGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 200, height: 35)
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        changeButton.layer.insertSublayer(gradient, at: 0)
        changeButton.setTitle("Change Password", for: .normal)
        changeButton.layer.cornerRadius = 16
        changeButton.layer.masksToBounds = true
        changeButton.tintColor = .white
        changeButton.addTarget(self, action: #selector(changePasswordButtonPressed), for: .touchUpInside)
        let constraints = [
            changeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeButton.topAnchor.constraint(equalTo: confirmNewPasswordTF.bottomAnchor, constant: 24),
            changeButton.widthAnchor.constraint(equalToConstant: 200),
            changeButton.heightAnchor.constraint(equalToConstant: 35),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func checkTF() -> String? {
        if oldPasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || newPasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmNewPasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Make sure you fill in all fields."
        }
        let oldPassword = oldPasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let newPassword = newPasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmNewPassword = confirmNewPasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if newPassword !=  confirmNewPassword {
            return "New password and confirmation password do not match."
        }
        if oldPassword == newPassword {
            return "New password should not be the same as old password"
        }
        return nil
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func changePasswordButtonPressed() {
        if let errorMessage = checkTF(){
            showAlert(title: "Error", message: errorMessage)
            return
        }
        guard let oldPassword = oldPasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        let oldCredentials = EmailAuthProvider.credential(withEmail: CurrentUser.email, password: oldPassword)
        currentUserNetworking.changePassword(oldCredentials)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func hideKeyboard(){
        view.endEditing(true)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
