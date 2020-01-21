//
//  WelcomeCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/20/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class WelcomeCell: UICollectionViewCell {
    
    var welcomeVC: WelcomeVC!
    
    var page: WelcomePage? {
        didSet {
            topicImage.image = UIImage(named: page?.imageName ?? "")
            topicLabel.text = page?.topicText
            descriptionLabel.text = page?.descriptionText
            if page?.topicText == "Start Messaging" {
                setupSignUpButton()
            }else{
                signUpButton.removeFromSuperview()
            }
        }
    }
    
    var topicImage = UIImageView()
    var topicLabel = UILabel()
    var descriptionLabel = UILabel()
    var signUpButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTopicImage()
        setupTopicLabel()
        setupDescriptionLabel()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTopicImage() {
        addSubview(topicImage)
        topicImage.translatesAutoresizingMaskIntoConstraints = false
        topicImage.contentMode = .scaleAspectFill
        topicImage.layer.cornerRadius = 75
        topicImage.layer.masksToBounds = true
        let constraints = [
            topicImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            topicImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -(center.y/2)),
            topicImage.widthAnchor.constraint(equalToConstant: 150),
            topicImage.heightAnchor.constraint(equalToConstant: 150),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupTopicLabel() {
        addSubview(topicLabel)
        topicLabel.translatesAutoresizingMaskIntoConstraints  = false
        topicLabel.font = UIFont(name: "Alata", size: 28)
        topicLabel.textAlignment = .center
        let constraints = [
            topicLabel.topAnchor.constraint(equalTo: topicImage.bottomAnchor, constant: 16),
            topicLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "Alata", size: 18)
        let constraints = [
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: topicLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupSignUpButton() {
        addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpButton.tintColor = .white
        signUpButton.layer.cornerRadius = 16
        signUpButton.layer.masksToBounds = true
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        let gradient = setupGradient()
        gradient.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        signUpButton.layer.insertSublayer(gradient, at: 0)
        let constraints = [
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 200),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func signUpButtonPressed() {
        self.welcomeVC.goToSignUpController()
    }
    
    func setupGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let topColor = UIColor(red: 95/255, green: 88/255, blue: 255/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 139/255, green: 134/255, blue: 255/255, alpha: 1).cgColor
        gradient.colors = [topColor, bottomColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.locations = [0, 1]
        return gradient
    }
    
}
