//
//  SignUpVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    var registerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGradientView()
        setupLogo()
        setupRegisterView()
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
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        let constraints = [
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/6),
            logoView.widthAnchor.constraint(equalToConstant: 100),
            logoView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
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
        setupSignUpLabel()
        RunLoop.current.add(timer, forMode: .default)
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
    
    @objc func animateSignUpViews() {
        for registerView in registerView.subviews {
            registerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            for registerView in self.registerView.subviews {
                registerView.alpha = 1
                registerView.transform = .identity
            }
        })
    }
    
    func setupBackButton() {
        let backButton = UIButton(type: .system)
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
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: false, completion: nil)
    }
    
}
