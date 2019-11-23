//
//  ChatCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/22/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    var message = UILabel()
    var messageBackground = UIView()
    var incomingConstraint: NSLayoutConstraint!
    var outcomingConstraint: NSLayoutConstraint!
    
    var isIncoming: Bool! {
        didSet{
            message.textColor = isIncoming ? .white : .black
            messageBackground.backgroundColor = isIncoming ? UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1) : .white
            if isIncoming {
                incomingConstraint.isActive = true
                outcomingConstraint.isActive = false
            }else{
                incomingConstraint.isActive = false
                outcomingConstraint.isActive = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(messageBackground)
        addSubview(message)
        setupMessageLabel()
        setupMessageBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMessageBackground(){
        messageBackground.backgroundColor = .blue
        messageBackground.layer.cornerRadius = 16
        
        messageBackground.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            messageBackground.topAnchor.constraint(equalTo: message.topAnchor, constant: -6),
            messageBackground.leadingAnchor.constraint(equalTo: message.leadingAnchor, constant: -16),
            messageBackground.bottomAnchor.constraint(greaterThanOrEqualTo: message.bottomAnchor, constant: 6),
            messageBackground.trailingAnchor.constraint(equalTo: message.trailingAnchor, constant: 16),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupMessageLabel() {
        message.numberOfLines = 0
        message.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints = [
            message.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            message.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            message.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ]
        outcomingConstraint = message.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        incomingConstraint = message.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        outcomingConstraint.isActive = false
        incomingConstraint.isActive = true
        NSLayoutConstraint.activate(constraints)
    }
    
}
