//
//  SignInVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, UITextFieldDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // SignInVC. This controller is responsible for authenticating users that are already in the database.
    
    var authNetworking: AuthNetworking!
    var authKeyboardHandler = AuthKeyboardHandler()
    var loginView: SignInView!
    var loginButton: AuthActionButton!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        authKeyboardHandler.view = view
        authKeyboardHandler.notificationCenterHandler()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUI(){
        view.backgroundColor = .white
        let _ = GradientLogoView(self, false)
        loginView = SignInView(self)
        let _ = SignInLogoAnimation(self)
        setupLoginButton()
        setupSignUpButton()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: TEXTFIELD VALIDATION
    
    private func validateTF() -> String?{
        if loginView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || loginView.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Make sure you fill in all fields"
        }
        
        let password = loginView.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.count < 6 {
            return "Password should be at least 6 characters long"
        }
        return nil
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLoginButton() {
        loginButton = AuthActionButton("SIGN IN", self)
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        let constraints = [
            loginButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: loginView.bottomAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupSignUpButton() {
        let signUpButton = UIButton(type: .system)
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        let mainString = "Don't have an account? Sign Up"
        let stringWithColor = "Sign Up"
        let range = (mainString as NSString).range(of: stringWithColor)
        let attributedString = NSMutableAttributedString(string: mainString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range)
        signUpButton.setAttributedTitle(attributedString, for: .normal)
        signUpButton.tintColor = .black
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        let constraints = [
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: ANIMATION TO SIGN UP VIEW
    
    @objc private func signUpButtonPressed() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            for subview in self.loginView.subviews {
                subview.alpha = 0
            }
            self.loginButton.alpha = 0
        }) { (true) in
            let controller = SignUpVC()
            controller.modalPresentationStyle = .fullScreen
            controller.signInVC = self
            self.present(controller, animated: false, completion: nil)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: LOGIN METHOD
    
    @objc private func loginButtonPressed() {
        loginView.errorLabel.text = ""
        let validation = validateTF()
        if validation != nil {
            loginView.errorLabel.text = validation!
            return
        }
        let password = loginView.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = loginView.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        authNetworking = AuthNetworking(self)
        authNetworking.signIn(with: email, and: password) { (error) in
            self.loginView.errorLabel.text = error?.localizedDescription
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

