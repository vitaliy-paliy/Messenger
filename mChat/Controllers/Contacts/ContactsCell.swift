//
//  ContactsCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {

    var profileImage = UIImageView()
    var friendName = UILabel()
    var friendEmail = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImage)
        addSubview(friendName)
        addSubview(friendEmail)
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
        friendEmail.numberOfLines = 0
        friendEmail.adjustsFontSizeToFitWidth = true
        friendEmail.textColor = .lightGray
        friendEmail.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            friendEmail.topAnchor.constraint(equalTo: friendName.bottomAnchor, constant: 0),
            friendEmail.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupNameLabel(){
        friendName.numberOfLines = 0
        friendName.adjustsFontSizeToFitWidth = true
        friendName.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            friendName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            friendName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
