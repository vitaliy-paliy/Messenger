//
//  SettingsCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/8/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let settingsImage = UIImageView()
    let settingsLabel = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSettingsImage()
        setupSettingsLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupSettingsImage(){
        addSubview(settingsImage)
        settingsImage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            settingsImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            settingsImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            settingsImage.widthAnchor.constraint(equalToConstant: 32),
            settingsImage.heightAnchor.constraint(equalToConstant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupSettingsLabel(){
        addSubview(settingsLabel)
        settingsLabel.textColor = .darkGray
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        let constraints = [
            settingsLabel.leadingAnchor.constraint(equalTo: settingsImage.trailingAnchor, constant: 8),
            settingsLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
