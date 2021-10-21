//
//  FriendRequestCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/5/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var controller: FriendRequestVC!
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let profileImage = UIImageView()
    let acceptButton = UIButton(type: .system)
    let declineButton = UIButton(type: .system)
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.isUserInteractionEnabled = true
        setupAcceptButton()
        setupDeclineButton()
        setupProfileImage()
        setupNameLabel()
        setupEmailLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupAcceptButton() {
        addSubview(acceptButton)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.setTitle("ACCEPT", for: .normal)
        acceptButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        let gradient = setupGradientLayer()
        gradient.frame = bounds
        acceptButton.layer.insertSublayer(gradient, at: 0)
        acceptButton.tintColor = .white
        acceptButton.layer.cornerRadius = 12
        acceptButton.layer.masksToBounds = true
        acceptButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        let constraints = [
            acceptButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            acceptButton.bottomAnchor.constraint(equalTo: centerYAnchor),
            acceptButton.widthAnchor.constraint(equalToConstant: 75),
            acceptButton.heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupDeclineButton() {
        addSubview(declineButton)
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        declineButton.setTitle("DECLINE", for: .normal)
        declineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        declineButton.tintColor = .lightGray
        declineButton.addTarget(self, action: #selector(declineButtonPressed), for: .touchUpInside)
        let constraints = [
            declineButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            declineButton.topAnchor.constraint(equalTo: centerYAnchor),
            declineButton.widthAnchor.constraint(equalToConstant: 75),
            declineButton.heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func addButtonPressed() {
        controller.addButtonPressed(cell: self)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func declineButtonPressed() {
        controller.declineButtonPressed(cell: self)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let firstColor = UIColor(red: 100/255, green: 200/255, blue: 110/255, alpha: 1).cgColor
        let secondColor = UIColor(red: 150/255, green: 210/255, blue: 130/255, alpha: 1).cgColor
        gradient.colors = [firstColor, secondColor]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.locations = [0, 1]
        return gradient
    }
        
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupProfileImage() {
        addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 30
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
        let constraints = [
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 60),
            profileImage.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        let constraints = [
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupEmailLabel() {
        addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.textColor = .lightGray
        emailLabel.font = UIFont.boldSystemFont(ofSize: 12)
        let constraints = [
            emailLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
            emailLabel.topAnchor.constraint(equalTo: centerYAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
