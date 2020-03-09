//
//  FriendInfoToolsCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/2/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class FriendInformationToolsCell: UITableViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let toolImage = UIImageView()
    let toolName = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupToolImage()
        setupToolName()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupToolImage(){
        addSubview(toolImage)
        toolImage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            toolImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            toolImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            toolImage.heightAnchor.constraint(equalToConstant: 30),
            toolImage.widthAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupToolName(){
        addSubview(toolName)
        toolName.translatesAutoresizingMaskIntoConstraints = false
        toolName.font = UIFont(name: "Helvetica Neue", size: 15)
        let constraints = [
            toolName.leadingAnchor.constraint(equalTo: toolImage.trailingAnchor, constant: 8),
            toolName.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
