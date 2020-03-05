//
//  EmptyListView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/26/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class EmptyListView: UIView{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var convVC: ConversationsVC!
    var contactsVC: ContactsVC!
    var controller: UIViewController!
    let emptyImageView = UIImageView()
    let emptyLabel = UILabel()
    let emptyButton = UIButton(type: .system)
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(_ contactsVC: ContactsVC?, _ convVC: ConversationsVC? , _ status: Bool) {
        super.init(frame: .zero)
        if contactsVC != nil {
            self.contactsVC = contactsVC
            self.controller = contactsVC
        }else{
            self.convVC = convVC
            self.controller = convVC
        }
        controller.view.addSubview(self)
        setupEmptyListView()
        setupEmptyLabel()
        setupGoToUserListButton()
        if status {
            emptyLabel.text = "It looks like you have not added any friends yet".uppercased()
            emptyButton.setTitle("Add Friends", for: .normal)
            emptyButton.addTarget(self, action: #selector(contactsButtonPressed), for: .touchUpInside)
        }else{
            emptyLabel.text = "It looks like you have not messaged any of your friends yet".uppercased()
            emptyButton.setTitle("Message", for: .normal)
            emptyButton.addTarget(self, action: #selector(convButtonPressed), for: .touchUpInside)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupEmptyListView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        frame = controller.view.frame
        addSubview(emptyImageView)
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyImageView.image = UIImage(systemName: "person.crop.circle.badge.xmark")
        emptyImageView.contentMode = .scaleAspectFill
        emptyImageView.tintColor = .black
        emptyImageView.alpha = 0.65
        let constraints = [
            emptyImageView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            emptyImageView.bottomAnchor.constraint(equalTo: controller.view.centerYAnchor, constant: -32),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)
        setupEmptyLabel()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupEmptyLabel() {
        addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.font = UIFont.boldSystemFont(ofSize: 16)
        emptyLabel.textColor = .gray
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        let constraints = [
            emptyLabel.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -32),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupGoToUserListButton() {
        emptyButton.translatesAutoresizingMaskIntoConstraints = false
        emptyButton.tintColor  = .white
        controller.view.addSubview(emptyButton)
        emptyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        emptyButton.layer.cornerRadius = 16
        emptyButton.layer.masksToBounds = true
        let gradient = controller.setupGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 200, height: 35)
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        emptyButton.layer.insertSublayer(gradient, at: 0)
        let constraints = [
            emptyButton.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            emptyButton.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor, constant: 8),
            emptyButton.widthAnchor.constraint(equalToConstant: 200),
            emptyButton.heightAnchor.constraint(equalToConstant: 35),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func contactsButtonPressed() {
        contactsVC.addButtonPressed()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func convButtonPressed(){
        convVC.newConversationTapped()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
