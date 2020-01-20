//
//  SignInVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignInVC: UIViewController, UITextFieldDelegate {
    
    var authNetworking = AuthNetworking()
    var loginView = UIView()
    var loginButton = UIButton(type: .system)
    var emailTextField = SkyFloatingLabelTextField()
    var passwordTextField = SkyFloatingLabelTextField()
    var errorLabel = UILabel()
    var keyboardIsShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientView()
        setupLoginView()
        notificationCenterHandler()
        hideKeyboardOnTap()
          setupLogo()
        view.backgroundColor = .white
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        keyboardIsShown = false
        return false
    }
    
    func notificationCenterHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height, let duration = kDuration else { return }
        if !keyboardIsShown {
            view.frame.origin.y -= height - 80
        }
        keyboardIsShown = true
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height else { return }
        view.frame.origin.y += height - 80
        guard let duration = kDuration else { return }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideKeyboardOnTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
        keyboardIsShown = false
    }
    
    func setupLogo() {
        let logoView = UIView()
        view.addSubview(logoView)
        logoView.backgroundColor = .white
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.layer.cornerRadius = 60
        logoView.layer.masksToBounds = true
        let logo = UIImageView()
        logo.image = UIImage(systemName: "bubble.middle.bottom.fill")
        logo.tintColor = UIColor(red: 70/255, green: 130/255, blue: 220/255, alpha: 1)
        logoView.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/6),
            logoView.widthAnchor.constraint(equalToConstant: 120),
            logoView.heightAnchor.constraint(equalToConstant: 120),
            logo.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 60),
            logo.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
        
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
    
    func setupGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let topColor = UIColor(red: 70/255, green: 130/255, blue: 220/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 85/255, green: 80/255, blue: 190/255, alpha: 1).cgColor
        gradient.colors = [topColor, bottomColor]
        gradient.locations = [0, 1]
        return gradient
    }
    
    func setupLoginView() {
        view.addSubview(loginView)
        loginView.backgroundColor = .white
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.layer.cornerRadius = 8
        loginView.layer.shadowRadius = 10
        loginView.layer.shadowOpacity = 0.3
        let constraints = [
            loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginView.heightAnchor.constraint(equalToConstant: 300)
        ]
        NSLayoutConstraint.activate(constraints)
        setupLoginLabel()
        setupLoginButton()
        setupEmailTextField()
        setupPasswordTextField()
        setupErrorLabel()
    }
    
    func setupLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Alata", size: 16)
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 18
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowOpacity = 0.1
        loginButton.backgroundColor = UIColor(red: 70/255, green: 100/255, blue: 200/255, alpha: 1)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        let constraints = [
            loginButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: loginView.bottomAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupLoginLabel() {
        let loginLabel = UILabel()
        loginView.addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.text = "Sign In"
        loginLabel.textAlignment = .center
        loginLabel.font = UIFont(name: "Alata", size: 24)
        loginLabel.textColor = .gray
        let constraints = [
            loginLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupEmailTextField() {
        loginView.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email"
        emailTextField.delegate = self
        emailTextField.titleFont = UIFont(name: "Alata", size: 12)!
        emailTextField.font = UIFont(name: "Alata", size: 18)
        emailTextField.selectedLineColor = UIColor(red: 70/255, green: 100/255, blue: 200/255, alpha: 1)
        emailTextField.lineColor = .lightGray
        let constraints = [
            emailTextField.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 64),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 120)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupPasswordTextField() {
        loginView.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.delegate = self
        passwordTextField.titleFont = UIFont(name: "Alata", size: 12)!
        passwordTextField.font = UIFont(name: "Alata", size: 18)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.selectedLineColor = UIColor(red: 70/255, green: 100/255, blue: 200/255, alpha: 1)
        passwordTextField.lineColor = .lightGray
        let constraints = [
            passwordTextField.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 120)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupErrorLabel() {
        loginView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.font = UIFont(name: "Helvetica Neue", size: 12)
        let constraints = [
            errorLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(constraints)
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
    
    @objc func loginButtonPressed() {
        errorLabel.text = ""
        let validation = validateTF()
        if validation != nil {
            errorLabel.text = validation!
            return
        }
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        authNetworking.signInVC = self
        authNetworking.signIn(with: email, and: password) { (error) in
            self.errorLabel.text = error?.localizedDescription
        }
    }
    
}
