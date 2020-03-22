//
//  UserInfoView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/3/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class UserInfoView: UIView{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var controller: AddFriendVC!
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let addButton = UIButton(type: .system)
    let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(_ controller: AddFriendVC) {
        super.init(frame: .zero)
        self.controller = controller
        setupUserProfileImage()
        setupNameLabel()
        setupEmailLabel()
        setupAddButton()
        setupLoadingIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUserProfileImage() {
        controller.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.loadImage(url: controller.user.profileImage ?? "")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        let constraints = [
            imageView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNameLabel() {
        controller.view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = controller.user.name?.uppercased()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let constraints = [
            nameLabel.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupEmailLabel() {
        controller.view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = controller.user.email?.uppercased()
        emailLabel.font = UIFont.boldSystemFont(ofSize: 14)
        emailLabel.textColor = .lightGray
        let constraints = [
            emailLabel.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupAddButton() {
        controller.view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = ThemeColors.mainColor
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        addButton.isHidden = true
        addButton.tintColor = .white
        addButton.layer.cornerRadius = 16
        addButton.layer.masksToBounds = true
        addButton.addTarget(controller, action: #selector(controller.addButtonPressed), for: .touchUpInside)
        let constraints = [
            addButton.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 35),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLoadingIndicator() {
        controller.view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = ThemeColors.mainColor
        let constraints = [
            loadingIndicator.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 35),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 35),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
