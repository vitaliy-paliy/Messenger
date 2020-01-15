//
//  SignInVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    var logo = UIImageView(image: UIImage(named: "logo"))
    var loginButton = UIButton(type: .system)
    var registerButton = UIButton(type: .system)
    var registerLabel = UILabel()
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLogo()
        setupTextFields()
        setupButtons()
        setupLabels()
    }
  
    func setupLogo(){
        view.addSubview(logo)
        setupImages(logo, .scaleAspectFill, 40, true)
        NSLayoutConstraint.activate(configureImagesConstraints(logo, 150, 150, view, 100))
    }
    
    func setupButtons(){
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        setupButton(loginButton, "Login")
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Sign Up", for: .normal)
        registerButton.titleLabel?.font = UIFont(name: "Optima", size: 12)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate(configureButtonsConstraints(loginButton, passwordTextField, 100, 40, 150))
        NSLayoutConstraint.activate(configureButtonsConstraints(registerButton, loginButton, 40, 20, 50, 60))
    }
    
    func setupLabels(){
        view.addSubview(registerLabel)
        configureLabels(registerLabel, "Don't have an Account?", color: .black, size: 12)
        let constraints = [
            registerLabel.heightAnchor.constraint(equalToConstant: 20),
            registerLabel.widthAnchor.constraint(equalToConstant: 175),
            registerLabel.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: 40),
            registerLabel.trailingAnchor.constraint(equalTo: registerButton.trailingAnchor, constant: -25),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupTextFields(){
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        emailTextField.autocapitalizationType = .none
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        setupTextField(emailTextField, "Email", emailPaddingView)
        setupTextField(passwordTextField, "Password", passwordPaddingView)
        passwordTextField.isSecureTextEntry = true
        NSLayoutConstraint.activate(configureTextFieldConstraints(emailTextField, logo, 170))
        NSLayoutConstraint.activate(configureTextFieldConstraints(passwordTextField, emailTextField, 45))
    }
    
    @objc func loginButtonPressed(_ sender: UIButton) {
        let validation = validateTF()
        if validation != nil {
            showAlert(title: "Error", message: validation!)
            return
        }
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }else{
                self.nextController()
            }
        }
    }
    
    func validateTF() -> String?{
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Make sure you fill in all fields."
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.count < 6 {
            return "Password should be at least 6 characters long."
        }
        
        return nil
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
            let controller = ChatTabBar()
            controller.modalPresentationStyle = .fullScreen
            ChatKit.map.showsUserLocation = true
            ChatKit.startUpdatingUserLocation()
            self.show(controller, sender: nil)
        }
    }
    
    @objc func registerButtonPressed(_ sender: UIButton){
        let controller = SignUpVC()
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
    
}
