//
//  LoginVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    var loginButton = UIButton()
    var registerButton = UIButton()
    var registerLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI(){
        setupButtons()
    }
    
    func setupButtons(){
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.layer.cornerRadius = 16
        loginButton.setTitle("Sign In", for: .normal)
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
            loginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 500),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 20),
            registerButton.widthAnchor.constraint(equalToConstant: 50),
            registerButton.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: 40),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupLabels(){
        view.addSubview(registerLabel)
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.text = "Don't have an account?"
        registerLabel.font = UIFont(name: "Optima", size: 12)
        registerLabel.backgroundColor = .black
        
    }
    
    
    @objc func loginButtonPressed(_ sender: UIButton) {
        // TODO: Add Login func.
    }
 
    @objc func registerButtonPressed(_ sender: UIButton){
        print("working")
    }
    
}
