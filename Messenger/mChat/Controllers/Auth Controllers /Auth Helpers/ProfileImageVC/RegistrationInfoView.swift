//
//  RegistrationInfoView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/28/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class RegistrationInfoView: UIView {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var controller: SelectProfileImageVC!
    var changeImageButton = UIButton()
    var profileImage: UIImageView!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(frame: CGRect, _ controller: SelectProfileImageVC, profileImage: UIImageView) {
        super.init(frame: frame)
        self.controller = controller
        self.profileImage = profileImage
        setupProfileView()
        setupInfoLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupProfileView() {
        controller.view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 75
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
        let constraints = [
            profileImage.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            profileImage.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupInfoLabels() {
        let nameLabel = UILabel()
        controller.view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = controller.name.uppercased()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        let emailLabel = UILabel()
        controller.view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = controller.email.uppercased()
        emailLabel.font = UIFont.boldSystemFont(ofSize: 12)
        emailLabel.textColor = .lightGray
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        setupChangeImageButton(emailLabel)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupChangeImageButton(_ emailLabel: UILabel) {
        controller.view.addSubview(changeImageButton)
        changeImageButton.frame = CGRect(x: 0, y: 0, width: 200, height: 35)
        changeImageButton.translatesAutoresizingMaskIntoConstraints = false
        changeImageButton.layer.cornerRadius = 8
        changeImageButton.setTitle("CHANGE PROFILE IMAGE", for: .normal)
        changeImageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        changeImageButton.layer.masksToBounds = true
        changeImageButton.tintColor = .white
        let gradient = controller.setupGradientLayer()
        gradient.frame = changeImageButton.frame
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        changeImageButton.layer.insertSublayer(gradient, at: 0)
        changeImageButton.addTarget(self, action: #selector(controller.changeImagePressed), for: .touchUpInside)
        let constraints = [
            changeImageButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            changeImageButton.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            changeImageButton.heightAnchor.constraint(equalToConstant: 35),
            changeImageButton.widthAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
