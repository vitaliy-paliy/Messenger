//
//  ProfileCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/18/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    var profileImage = UIImageView()
    var nameLabel = UILabel()
    var emailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(emailLabel)
        setupImage()
        setupNameLabel()
        setupEmailLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func setupImage(){
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
    
    func setupEmailLabel(){
        emailLabel.numberOfLines = 0
        emailLabel.adjustsFontSizeToFitWidth = true
        emailLabel.textColor = .lightGray
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            emailLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupNameLabel(){
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
