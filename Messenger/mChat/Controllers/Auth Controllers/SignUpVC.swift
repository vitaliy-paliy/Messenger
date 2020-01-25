//
//  SignUpVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    let backButton = UIButton(type: .system)
    let continueButton = UIButton(type: .system)
    var nameTextField = SkyFloatingLabelTextField()
    var emailTextField = SkyFloatingLabelTextField()
    var passwordTextField = SkyFloatingLabelTextField()
    var registerView = UIView()
    var errorLabel = UILabel()
    var authNetworking = AuthNetworking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGradientView()
        setupLogo()
        setupRegisterView()
        setupContinueButton()
        setupBackButton()
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
        let topColor = UIColor(red: 100/255, green: 90/255, blue: 255/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 140/255, green: 135/255, blue: 255/255, alpha: 1).cgColor
        gradient.colors = [topColor, bottomColor]
        gradient.locations = [0, 1]
        return gradient
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
    
    func setupRegisterView() {
        view.addSubview(registerView)
        registerView.backgroundColor = .white
        registerView.translatesAutoresizingMaskIntoConstraints = false
        registerView.layer.cornerRadius = 8
        registerView.layer.shadowRadius = 10
        registerView.layer.shadowOpacity = 0.3
        var height: CGFloat = 280
        if view.frame.height > 1000 { height = 600 }
        let constraints = [
            registerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            registerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            registerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            registerView.heightAnchor.constraint(equalToConstant: height)
        ]
        NSLayoutConstraint.activate(constraints)
        let timer = Timer(timeInterval: 0.5, target: self, selector: #selector(animateSignUpViews), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .default)
        setupSignUpLabel()
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupErrorLabel()
    }
    
    func setupSignUpLabel() {
        let signUpLabel = UILabel()
        registerView.addSubview(signUpLabel)
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.text = "Sign Up"
        signUpLabel.textAlignment = .center
        signUpLabel.font = UIFont(name: "Alata", size: 24)
        signUpLabel.textColor = .gray
        let constraints = [
            signUpLabel.centerXAnchor.constraint(equalTo: registerView.centerXAnchor),
            signUpLabel.topAnchor.constraint(equalTo: registerView.topAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(constraints)
        signUpLabel.alpha = 0
    }
    
    func setupBackButton() {
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
        backButton.alpha = 0
    }
    
    func setupContinueButton() {
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.setTitle("CONTINUE", for: .normal)
        continueButton.tintColor = AppColors.mainColor
        continueButton.titleLabel?.textAlignment = .center
        continueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        let constraints = [
            continueButton.bottomAnchor.constraint(equalTo: registerView.bottomAnchor, constant: -16),
            continueButton.centerXAnchor.constraint(equalTo: registerView.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        continueButton.alpha = 0
    }
    
    func setupNameTextField() {
        registerView.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Name"
        nameTextField.delegate = self
        nameTextField.titleFont = UIFont(name: "Alata", size: 12)!
        nameTextField.font = UIFont(name: "Alata", size: 18)
        nameTextField.selectedLineColor = UIColor(red: 70/255, green: 100/255, blue: 200/255, alpha: 1)
        nameTextField.lineColor = .lightGray
        let constraints = [
            nameTextField.centerXAnchor.constraint(equalTo: registerView.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: registerView.topAnchor, constant: 48),
            nameTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 120)
        ]
        NSLayoutConstraint.activate(constraints)
        nameTextField.alpha = 0
    }
    
    func setupEmailTextField() {
        registerView.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email"
        emailTextField.delegate = self
        emailTextField.titleFont = UIFont(name: "Alata", size: 12)!
        emailTextField.font = UIFont(name: "Alata", size: 18)
        emailTextField.selectedLineColor = UIColor(red: 70/255, green: 100/255, blue: 200/255, alpha: 1)
        emailTextField.lineColor = .lightGray
        let constraints = [
            emailTextField.centerXAnchor.constraint(equalTo: registerView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 120)
        ]
        NSLayoutConstraint.activate(constraints)
        emailTextField.alpha = 0
    }
    
    func setupPasswordTextField() {
        registerView.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.delegate = self
        passwordTextField.titleFont = UIFont(name: "Alata", size: 12)!
        passwordTextField.font = UIFont(name: "Alata", size: 18)
        passwordTextField.selectedLineColor = UIColor(red: 70/255, green: 100/255, blue: 200/255, alpha: 1)
        passwordTextField.lineColor = .lightGray
        let constraints = [
            passwordTextField.centerXAnchor.constraint(equalTo: registerView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 120)
        ]
        NSLayoutConstraint.activate(constraints)
        passwordTextField.alpha = 0
    }
    
    func setupErrorLabel() {
        registerView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.font = UIFont(name: "Helvetica Neue", size: 12)
        let constraints = [
            errorLabel.centerXAnchor.constraint(equalTo: registerView.centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: registerView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: registerView.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func animateSignUpViews() {
        for registerView in registerView.subviews {
            registerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        backButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        continueButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            for registerView in self.registerView.subviews {
                registerView.alpha = 1
                registerView.transform = .identity
            }
            self.backButton.transform = .identity
            self.continueButton.transform = .identity
            self.backButton.alpha = 1
            self.continueButton.alpha = 1
        })
    }
    
    func validateTF() -> String?{
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Make sure you fill in all fields."
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if password.count < 6 {
            return "Password should be at least 6 characters long."
        }
        
        if name.count > 30 {
            return "Your name exceeds a limit of 30 characters."
        }
        
        if email.count > 30 {
            return "Your email exceeds a limit of 30 characters."
        }
        
        return nil
    }
    
    @objc func continueButtonPressed() {
        errorLabel.text = ""
        let validation = validateTF()
        if validation != nil {
            errorLabel.text = validation
            return
        }
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        authNetworking.checkForExistingEmail(email) { (errorMessage) in
            guard errorMessage == nil else {
                self.errorLabel.text = errorMessage
                return
            }
            let controller = SelectProfileImageVC()
            controller.modalPresentationStyle = .fullScreen
            controller.name = name
            controller.email = email
            controller.password = password
            self.show(controller, sender: nil)
        }
    }
    
}
