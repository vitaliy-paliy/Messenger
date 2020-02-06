//
//  FriendRequestCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/5/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAcceptButton()
        setupDeclineButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAcceptButton() {
        let acceptButton = UIButton(type: .system)
        addSubview(acceptButton)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.setTitle("ACCEPT", for: .normal)
        acceptButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        let gradient = setupGradientLayer()
        gradient.frame = bounds
        acceptButton.layer.insertSublayer(gradient, at: 0)
        acceptButton.tintColor = .white
        acceptButton.layer.cornerRadius = 12
        acceptButton.layer.masksToBounds = true
        acceptButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        let constraints = [
            acceptButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            acceptButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16),
            acceptButton.widthAnchor.constraint(equalToConstant: 75),
            acceptButton.heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupDeclineButton() {
        let declineButton = UIButton(type: .system)
        addSubview(declineButton)
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        declineButton.setTitle("DECLINE", for: .normal)
        declineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        declineButton.tintColor = .lightGray
        declineButton.addTarget(self, action: #selector(declineButtonPressed), for: .touchUpInside)
        let constraints = [
            declineButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            declineButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 8),
            declineButton.widthAnchor.constraint(equalToConstant: 75),
            declineButton.heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func addButtonPressed() {
        print("Add")
    }
    
    @objc func declineButtonPressed() {
        print("Decline")
    }
    
    func setupGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let firstColor = UIColor(red: 100/255, green: 200/255, blue: 110/255, alpha: 1).cgColor
        let secondColor = UIColor(red: 150/255, green: 210/255, blue: 130/255, alpha: 1).cgColor
        gradient.colors = [firstColor, secondColor]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.locations = [0, 1]
        return gradient
    }
    
}
