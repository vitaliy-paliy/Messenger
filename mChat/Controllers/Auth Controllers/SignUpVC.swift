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
        configureTF()
        configureButtons()
    }
    
    func setupLogo(){
        view.addSubview(logo)
        setupImages(logo, .scaleAspectFill, 40, true)
        NSLayoutConstraint.activate(configureImagesConstraints(logo, 150, 150, view, 100))
    }
    
    func configureButtons() {
        view.addSubview(signUpButton)
        view.addSubview(backButton)
        setupButton(signUpButton, "Sign Up")
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed(_:)), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.layer.cornerRadius = 20
        backButton.backgroundColor = Constants.Colors.appColor
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.tintColor = .white
        
        let constraints = [
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(configureButtonsConstraints(signUpButton, confirmTF, 70, 40, 150))
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureTF(){
        view.addSubview(nameTF)
        view.addSubview(passwordTF)
        view.addSubview(confirmTF)
        view.addSubview(emailTF)
        let namePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        setupTextField(nameTF, "Enter your name", namePaddingView)
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        setupTextField(emailTF, "Enter your Email", emailPaddingView)
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        setupTextField(passwordTF, "Enter your password", passwordPaddingView)
        passwordTF.isSecureTextEntry = true
        let confirmPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        setupTextField(confirmTF, "Confirm your password", confirmPaddingView)
        confirmTF.isSecureTextEntry = true
        NSLayoutConstraint.activate(configureTextFieldConstraints(nameTF, logo, 170))
        NSLayoutConstraint.activate(configureTextFieldConstraints(emailTF, nameTF, 45))
        NSLayoutConstraint.activate(configureTextFieldConstraints(passwordTF, emailTF, 45))
        NSLayoutConstraint.activate(configureTextFieldConstraints(confirmTF, passwordTF, 45))
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
