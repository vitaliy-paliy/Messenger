//
//  SignInVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    var logo = UIImageView(image: UIImage(named: "logo"))
    var loginButton = UIButton()
    var registerButton = UIButton()
    var registerLabel = UILabel()
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI(){
        setupLogo()
        setupTextFields()
        setupButtons()
        setupLabels()
    }
    
    func setupLogo(){
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFill
        logo.layer.cornerRadius = 40
        logo.layer.masksToBounds = true
        let constraints = [
            logo.heightAnchor.constraint(equalToConstant: 150),
            logo.widthAnchor.constraint(equalToConstant: 150),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupButtons(){
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.layer.cornerRadius = 16
        loginButton.setTitle("Sign In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        registerButton.setTitle("Sign Up", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Optima", size: 20)
        registerButton.titleLabel?.font = UIFont(name: "Optima", size: 12)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.backgroundColor = UIColor(displayP3Red: 71/255, green: 94/255, blue: 208/255, alpha: 1)
        loginButton.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
        let constraints = [
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 100),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 20),
            registerButton.widthAnchor.constraint(equalToConstant: 50),
            registerButton.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: 40),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupLabels(){
        view.addSubview(registerLabel)
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.text = "Don't have an account?"
        registerLabel.font = UIFont(name: "Optima", size: 12)
        registerLabel.textColor = .black
        let constraints = [
            registerLabel.heightAnchor.constraint(equalToConstant: 20),
            registerLabel.widthAnchor.constraint(equalToConstant: 150),
            registerLabel.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: 40),
            registerLabel.trailingAnchor.constraint(equalTo: registerButton.trailingAnchor, constant: -20),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupTextFields(){
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email"
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        emailTextField.leftView = emailPaddingView
        emailTextField.leftViewMode = .always
        emailTextField.backgroundColor = UIColor(displayP3Red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        emailTextField.layer.cornerRadius = 16
        emailTextField.borderStyle = .none
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = .always
        passwordTextField.backgroundColor = UIColor(displayP3Red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        passwordTextField.layer.cornerRadius = 16
        passwordTextField.borderStyle = .none
        
        let constraits = [
            emailTextField.topAnchor.constraint(equalTo: logo.topAnchor, constant: 170),
            emailTextField.widthAnchor.constraint(equalToConstant: 200),
            emailTextField.heightAnchor.constraint(equalToConstant: 35),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 45),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraits)
        
    }
    
    @objc func loginButtonPressed(_ sender: UIButton) {
        let controller = ChatTabBar()
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
    
    @objc func registerButtonPressed(_ sender: UIButton){
        let controller = SignUpVC()
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
    
}
