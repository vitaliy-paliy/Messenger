//
//  ChangeEmailVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/27/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Lottie

class ChangeEmailVC: UIViewController {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let infoAnimView = AnimationView()
    let currentUserNetworking = CurrentUserNetworking()
    let newEmailTF = UITextField()
    let confirmNewEmailTF = UITextField()
    let infoLabel = UILabel()
    let changeButton = UIButton(type: .system)
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserNetworking.changeEmailVC = self
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
        navigationItem.title = "Change Email"
        setupInfoLabel()
        setupChangeInfoAnim()
        setupNewEmailTF()
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
        infoLabel.text = "Here you can change your email.\nNOTE: \nA valid email must be in this format youremail@email.com."
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
    
    private func setupNewEmailTF() {
        view.addSubview(newEmailTF)
        newEmailTF.translatesAutoresizingMaskIntoConstraints = false
        setupTF(newEmailTF)
        newEmailTF.placeholder = "New Email"
        let constraints = [
            newEmailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newEmailTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            newEmailTF.widthAnchor.constraint(equalToConstant: 250),
            newEmailTF.heightAnchor.constraint(equalToConstant: 35),
        ]
        NSLayoutConstraint.activate(constraints)
        setupConfirmTF()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupConfirmTF() {
        view.addSubview(confirmNewEmailTF)
        confirmNewEmailTF.translatesAutoresizingMaskIntoConstraints = false
        setupTF(confirmNewEmailTF)
        confirmNewEmailTF.placeholder = "Confirm New Email"
        let constraints = [
            confirmNewEmailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmNewEmailTF.topAnchor.constraint(equalTo: newEmailTF.bottomAnchor, constant: 8),
            confirmNewEmailTF.widthAnchor.constraint(equalToConstant: 250),
            confirmNewEmailTF.heightAnchor.constraint(equalToConstant: 35),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTF(_ textfield: UITextField) {
        textfield.borderStyle = .none
        textfield.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textfield.layer.cornerRadius = 16
        textfield.layer.masksToBounds = true
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
        changeButton.setTitle("Change Email", for: .normal)
        changeButton.layer.cornerRadius = 16
        changeButton.layer.masksToBounds = true
        changeButton.tintColor = .white
        changeButton.addTarget(self, action: #selector(changeEmailButtonPressed), for: .touchUpInside)
        let constraints = [
            changeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeButton.topAnchor.constraint(equalTo: confirmNewEmailTF.bottomAnchor, constant: 24),
            changeButton.widthAnchor.constraint(equalToConstant: 200),
            changeButton.heightAnchor.constraint(equalToConstant: 35),
        ]
        NSLayoutConstraint.activate(constraints)
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
    
    private func checkTF() -> String?{
        if newEmailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmNewEmailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Make sure you fill in all fields."
        }
        let newEmail = newEmailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmNewEmail = confirmNewEmailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if !newEmail!.isValidEmail {
            return "Please make sure to provide valid email format."
        }
        if newEmail !=  confirmNewEmail {
            return "New email and confirmation email do not match."
        }
        return nil
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func changeEmailButtonPressed() {
        if let errorMessage = checkTF() {
            showAlert(title: "Error", message: errorMessage)
            return
        }
        guard let newEmail = newEmailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        currentUserNetworking.changeEmail(newEmail)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}


