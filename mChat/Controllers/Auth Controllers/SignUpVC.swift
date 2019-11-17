//
//  SignUpVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    var logo = UIImageView(image: UIImage(named: "logo"))
    var signUpButton = UIButton()
    var backButton = UIButton()
    var emailTF = UITextField()
    var nameTF = UITextField()
    var passwordTF = UITextField()
    var confirmTF = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupUI() {
        setupLogo()
        setupTF()
        setupButtons()
    }
    
    func setupLogo(){
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.layer.cornerRadius = 40
        logo.layer.masksToBounds = true
        logo.contentMode = .scaleAspectFill
        let constraints = [
            
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logo.heightAnchor.constraint(equalToConstant: 150),
            logo.widthAnchor.constraint(equalToConstant: 150),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupButtons() {
        view.addSubview(signUpButton)
        view.addSubview(backButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 16
        signUpButton.backgroundColor = Constants.Colors.appColor
        signUpButton.titleLabel?.font = UIFont(name: "Optima", size: 20)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed(_:)), for: .touchUpInside)
        
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.layer.cornerRadius = 20
        backButton.backgroundColor = Constants.Colors.appColor
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.tintColor = .white
        
        let constraints = [
            signUpButton.topAnchor.constraint(equalTo: confirmTF.topAnchor, constant: 70),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.widthAnchor.constraint(equalToConstant: 150),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupTF(){
        view.addSubview(nameTF)
        view.addSubview(passwordTF)
        view.addSubview(confirmTF)
        view.addSubview(emailTF)
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        nameTF.placeholder = "Enter your name"
        let namePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        nameTF.leftView = namePaddingView
        nameTF.backgroundColor = UIColor(displayP3Red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        nameTF.leftViewMode = .always
        nameTF.borderStyle = .none
        nameTF.layer.cornerRadius = 16
        
        emailTF.translatesAutoresizingMaskIntoConstraints = false
        emailTF.placeholder = "Enter your Email"
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        emailTF.leftView = emailPaddingView
        emailTF.leftViewMode = .always
        emailTF.backgroundColor = UIColor(displayP3Red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        emailTF.borderStyle = .none
        emailTF.layer.cornerRadius = 16
        emailTF.autocapitalizationType = .none
        
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        passwordTF.placeholder = "Enter your password"
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        passwordTF.leftView = passwordPaddingView
        passwordTF.backgroundColor = UIColor(displayP3Red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        passwordTF.leftViewMode = .always
        passwordTF.borderStyle = .none
        passwordTF.layer.cornerRadius = 16
        passwordTF.isSecureTextEntry = true
        
        confirmTF.translatesAutoresizingMaskIntoConstraints = false
        confirmTF.placeholder = "Confirm your password"
        let confirmPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        confirmTF.leftView = confirmPaddingView
        confirmTF.backgroundColor = UIColor(displayP3Red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        confirmTF.leftViewMode = .always
        confirmTF.borderStyle = .none
        confirmTF.layer.cornerRadius = 16
        confirmTF.isSecureTextEntry = true
        
        let constraints = [
            nameTF.topAnchor.constraint(equalTo: logo.topAnchor, constant: 170),
            nameTF.heightAnchor.constraint(equalToConstant: 35),
            nameTF.widthAnchor.constraint(equalToConstant: 200),
            nameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTF.topAnchor.constraint(equalTo: nameTF.topAnchor, constant: 45),
            emailTF.heightAnchor.constraint(equalToConstant: 35),
            emailTF.widthAnchor.constraint(equalToConstant: 200),
            emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTF.topAnchor.constraint(equalTo: emailTF.topAnchor, constant: 45),
            passwordTF.heightAnchor.constraint(equalToConstant: 35),
            passwordTF.widthAnchor.constraint(equalToConstant: 200),
            passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmTF.topAnchor.constraint(equalTo: passwordTF.topAnchor, constant: 45),
            confirmTF.heightAnchor.constraint(equalToConstant: 35),
            confirmTF.widthAnchor.constraint(equalToConstant: 200),
            confirmTF.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func signUpButtonPressed(_ sender: UIButton){
        let validation = validateTF()
        if validation != nil {
            showAlert(title: "Error", message: validation)
        }
        guard let name = nameTF.text, let password = passwordTF.text, let email = emailTF.text else { return }
        let controller = SelectProfileImageVC()
        controller.email = email
        controller.name = name
        controller.password = password
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
    
    func validateTF() -> String?{
        if nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Make sure you fill in all fields."
        }
        
        let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirm  = confirmTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if password.count < 6 {
            return "Password should be at least 6 characters long."
        }
        
        if password != confirm {
            return "Your passwords should match"
        }
        
        return nil
    }
    
    @objc func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
