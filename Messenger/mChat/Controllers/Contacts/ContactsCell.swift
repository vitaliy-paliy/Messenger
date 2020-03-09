//
//  ContactsCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let profileImage = UIImageView()
    let friendName = UILabel()
    let friendEmail = UILabel()
    let isOnlineView = UIView()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupImage()
        setupNameLabel()
        setupEmailLabel()
        setupIsOnlineImage()
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
    
    private func setupIsOnlineImage(){
        addSubview(isOnlineView)
        isOnlineView.layer.cornerRadius = 8
        isOnlineView.layer.borderColor = UIColor.white.cgColor
        isOnlineView.layer.borderWidth = 2.5
        isOnlineView.layer.masksToBounds = true
        isOnlineView.backgroundColor = UIColor(displayP3Red: 90/255, green: 180/255, blue: 55/255, alpha: 1)
        isOnlineView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            isOnlineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
            isOnlineView.widthAnchor.constraint(equalToConstant: 16),
            isOnlineView.heightAnchor.constraint(equalToConstant: 16),
            isOnlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupEmailLabel(){
        addSubview(friendEmail)
        friendEmail.numberOfLines = 0
        friendEmail.adjustsFontSizeToFitWidth = true
        friendEmail.textColor = .gray
        friendEmail.font = UIFont(name: "Helvetica Neue", size: 16)
        friendEmail.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            friendEmail.topAnchor.constraint(equalTo: friendName.bottomAnchor),
            friendEmail.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNameLabel(){
        addSubview(friendName)
        friendName.textColor = .black
        friendName.numberOfLines = 0
        friendName.translatesAutoresizingMaskIntoConstraints = false
        friendName.font = UIFont(name: "Helvetica Neue", size: 18)
        let constraints = [
            friendName.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            friendName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
