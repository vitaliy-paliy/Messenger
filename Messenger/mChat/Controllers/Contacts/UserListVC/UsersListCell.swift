//
//  UsersListCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/18/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class UsersListCell: UITableViewCell {

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let profileImage = UIImageView()
    let userName = UILabel()
    let userEmail = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //s
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImage()
        setupNameLabel()
        setupEmailLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupImage(){
        addSubview(profileImage)
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 40
        profileImage.layer.masksToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            profileImage.heightAnchor.constraint(equalToConstant: 80),
            profileImage.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupEmailLabel(){
        addSubview(userEmail)
        userEmail.numberOfLines = 0
        userEmail.adjustsFontSizeToFitWidth = true
        userEmail.textColor = .lightGray
        userEmail.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            userEmail.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 0),
            userEmail.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNameLabel(){
        addSubview(userName)
        userName.numberOfLines = 0
        userName.adjustsFontSizeToFitWidth = true
        userName.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            userName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
