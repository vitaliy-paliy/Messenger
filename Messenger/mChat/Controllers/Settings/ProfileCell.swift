//
//  ProfileCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/18/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let profileImage = UIImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let darkBackground = UIView()
    var settingsVC: SettingsVC!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImage()
        setupNameLabel()
        setupEmailLabel()
        setupDarkBackground()
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
        addSubview(emailLabel)
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNameLabel(){
        addSubview(nameLabel)
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupDarkBackground() {
        profileImage.addSubview(darkBackground)
        darkBackground.translatesAutoresizingMaskIntoConstraints = false
        darkBackground.backgroundColor = UIColor.black
        darkBackground.alpha = 0.25
        darkBackground.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeImageViewTouched))
        darkBackground.addGestureRecognizer(tap)
        let constraints = [
            darkBackground.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            darkBackground.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor),
            darkBackground.topAnchor.constraint(equalTo: profileImage.topAnchor),
            darkBackground.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        setupChangeImageView()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupChangeImageView() {
        let changeImageView = UIImageView()
        profileImage.addSubview(changeImageView)
        changeImageView.translatesAutoresizingMaskIntoConstraints = false
        changeImageView.image = UIImage(systemName: "camera.circle.fill")
        changeImageView.contentMode = .scaleAspectFill
        changeImageView.tintColor = .white
        let constraints = [
            changeImageView.centerYAnchor.constraint(equalTo: darkBackground.centerYAnchor),
            changeImageView.centerXAnchor.constraint(equalTo: darkBackground.centerXAnchor),
            changeImageView.widthAnchor.constraint(equalToConstant: 36),
            changeImageView.heightAnchor.constraint(equalToConstant: 36)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func changeImageViewTouched() {
        settingsVC.changeProfileImage()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
