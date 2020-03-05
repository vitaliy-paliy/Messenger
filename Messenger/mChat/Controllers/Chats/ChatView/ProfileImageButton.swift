//
//  ProfileImageButton.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/31/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ProfileImageButton: UIButton {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(chatVC: ChatVC, url: String) {
        super.init(frame: .zero)
        setupProfileImage(url, chatVC)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupProfileImage(_ url: String, _ chatVC: ChatVC){
        let friendImageIcon = UIImageView()
        friendImageIcon.loadImage(url: url)
        addSubview(friendImageIcon)
        friendImageIcon.translatesAutoresizingMaskIntoConstraints = false
        friendImageIcon.contentMode = .scaleAspectFill
        friendImageIcon.layer.cornerRadius = 16
        friendImageIcon.layer.masksToBounds = true
        let constraints = [
            friendImageIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
            friendImageIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendImageIcon.heightAnchor.constraint(equalToConstant: 32),
            friendImageIcon.widthAnchor.constraint(equalToConstant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
        addTarget(chatVC, action: #selector(chatVC.profileImageTapped), for: .touchUpInside)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
