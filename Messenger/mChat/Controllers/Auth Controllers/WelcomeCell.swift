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
                setupSignInButton()
            }else{
                signInButton.removeFromSuperview()
            }
        }
    }
    
    var topicImage = UIImageView()
    var topicLabel = UILabel()
    var descriptionLabel = UILabel()
    var signUpButton = UIButton(type: .system)
    var signInButton = UIButton(type: .system)
    
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
    
    func setupGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let topColor = UIColor(red: 100/255, green: 90/255, blue: 255/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 140/255, green: 135/255, blue: 255/255, alpha: 1).cgColor
        gradient.colors = [topColor, bottomColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.locations = [0, 1]
        return gradient
    }
    
    func setupSignInButton() {
        addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("SIGN IN", for: .normal)
        signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        signInButton.tintColor = .white
        signInButton.layer.shadowColor = UIColor.black.cgColor
        signInButton.layer.shadowRadius = 2
        signInButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        signInButton.layer.shadowOpacity = 0.3
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        let gradient = setupGradient()
        gradient.frame = CGRect(x: 0, y: 0, width: 250, height: 40)
        gradient.cornerRadius = 4
        signInButton.layer.insertSublayer(gradient, at: 0)
        let constraints = [
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 250),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            signInButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func signInButtonPressed() {
        welcomeVC.goToSignInController()
    }
    
}
