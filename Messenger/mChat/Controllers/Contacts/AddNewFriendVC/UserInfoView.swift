//
//  UserInfoView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/3/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class UserInfoView: UIView{
    
    var controller: AddFriendVC!
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    
    init(_ controller: AddFriendVC) {
        super.init(frame: .zero)
        self.controller = controller
        setupUserProfileImage()
        setupNameLabel()
        setupEmailLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUserProfileImage() {
        controller.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.loadImage(url: controller.friend.profileImage)
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
    
    func setupNameLabel() {
        controller.view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = controller.friend.name.uppercased()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let constraints = [
            nameLabel.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupEmailLabel() {
        controller.view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = controller.friend.email.uppercased()
        emailLabel.font = UIFont.boldSystemFont(ofSize: 14)
        emailLabel.textColor = .lightGray
        let constraints = [
            emailLabel.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
}
