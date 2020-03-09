//
//  FriendInfoCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/2/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class FriendInformationCell: UITableViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let nameLabel = UILabel()
    let onlineLabel = UILabel()
    let profileImage = UIImageView()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProfileImage()
        setupName()
        setupIsOnlineLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupProfileImage(){
        addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 35
        profileImage.layer.masksToBounds = true
        let constraints = [
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupName(){
        handleLabelSetup(for: nameLabel, -20)
        nameLabel.font = UIFont(name: "Helvetica Neue", size: 18)
        nameLabel.textColor = .black
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupIsOnlineLabel(){
        handleLabelSetup(for: onlineLabel, 0)
        onlineLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        onlineLabel.textColor = .lightGray
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func handleLabelSetup(for label: UILabel, _ const: CGFloat){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            label.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: const)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
