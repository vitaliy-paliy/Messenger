//
//  NewConversationCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/1/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class NewConversationCell: UITableViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let profileImage = UIImageView()
    let friendName = UILabel()
    let friendEmail = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
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
        profileImage.layer.cornerRadius = 30
        profileImage.layer.masksToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            profileImage.heightAnchor.constraint(equalToConstant: 60),
            profileImage.widthAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNameLabel(){
        addSubview(friendName)
        friendName.textColor = .black
        friendName.numberOfLines = 0
        friendName.adjustsFontSizeToFitWidth = true
        friendName.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            friendName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            friendName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupEmailLabel(){
        addSubview(friendEmail)
        friendEmail.numberOfLines = 0
        friendEmail.adjustsFontSizeToFitWidth = true
        friendEmail.textColor = .gray
        friendEmail.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            friendEmail.topAnchor.constraint(equalTo: friendName.bottomAnchor, constant: 0),
            friendEmail.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
