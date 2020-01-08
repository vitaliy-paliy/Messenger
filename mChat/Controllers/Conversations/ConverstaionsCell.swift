//
//  ConversationsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class ConversationsCell: UITableViewCell {
    
    var message: Messages!
    var profileImage = UIImageView()
    var friendName = UILabel()
    var recentMessage = UILabel()
    var timeLabel = UILabel()
    var isOnlineView = UIView()
    var isTypingView = UIView()
    let typingAnimation = AnimationView()
    var unreadMessageView = UIView()
    var unreadLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupImage()
        setupNameLabel()
        setupUnreadMessagesView()
        setupRecentMessage()
        setupTimeLabel()
        setupIsOnlineImage()
        setupUserTypingView()
        setupUnreadMessagesView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupIsOnlineImage(){
        addSubview(isOnlineView)
        isOnlineView.isHidden = true
        isOnlineView.layer.cornerRadius = 8
        isOnlineView.layer.borderColor = UIColor.white.cgColor
        isOnlineView.layer.borderWidth = 2.5
        isOnlineView.layer.masksToBounds = true
        isOnlineView.backgroundColor = UIColor(displayP3Red: 116/255, green: 195/255, blue: 168/255, alpha: 1)
        isOnlineView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            isOnlineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
            isOnlineView.widthAnchor.constraint(equalToConstant: 16),
            isOnlineView.heightAnchor.constraint(equalToConstant: 16),
            isOnlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupImage(){
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
    
    func setupRecentMessage(){
        addSubview(recentMessage)
        recentMessage.textColor = .lightGray
        recentMessage.font = UIFont(name: "Helvetica Neue", size: 16)
        recentMessage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            recentMessage.centerYAnchor.constraint(equalTo: centerYAnchor),
            recentMessage.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
            recentMessage.trailingAnchor.constraint(equalTo: unreadMessageView.leadingAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupTimeLabel(){
        addSubview(timeLabel)
        timeLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        timeLabel.textAlignment = .left
        timeLabel.numberOfLines = 0
        timeLabel.textColor = .lightGray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupNameLabel(){
        addSubview(friendName)
        friendName.textColor = .black
        friendName.font = UIFont(name: "Helvetica Neue", size: 18)
        friendName.numberOfLines = 0
        friendName.adjustsFontSizeToFitWidth = true
        friendName.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            friendName.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            friendName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupUserTypingView(){
        isTypingView.isHidden = true
        let typingText = UILabel()
        typingText.font = UIFont(name: "Helvetica Neue", size: 16)
        typingText.textColor = .gray
        typingText.text = "typing"
        isTypingView.backgroundColor = .clear
        isTypingView.layer.cornerRadius = 12.5
        isTypingView.layer.masksToBounds = true
        addSubview(isTypingView)
        isTypingView.addSubview(typingText)
        isTypingView.addSubview(typingAnimation)
        isTypingView.translatesAutoresizingMaskIntoConstraints = false
        typingAnimation.translatesAutoresizingMaskIntoConstraints = false
        typingText.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            isTypingView.widthAnchor.constraint(equalToConstant: 100),
            isTypingView.heightAnchor.constraint(equalToConstant: 25),
            isTypingView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8),
            isTypingView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            typingText.widthAnchor.constraint(equalToConstant: 50),
            typingText.heightAnchor.constraint(equalToConstant: 25),
            typingText.centerYAnchor.constraint(equalTo: isTypingView.centerYAnchor, constant: 3),
            typingText.trailingAnchor.constraint(equalTo: isTypingView.trailingAnchor),
            typingAnimation.leadingAnchor.constraint(equalTo: isTypingView.leadingAnchor, constant: 0),
            typingAnimation.bottomAnchor.constraint(equalTo: isTypingView.bottomAnchor),
            typingAnimation.topAnchor.constraint(equalTo: isTypingView.topAnchor),
            typingAnimation.trailingAnchor.constraint(equalTo: typingText.leadingAnchor, constant: -2),
        ]
        NSLayoutConstraint.activate(constraints)
        typingAnimation.animationSpeed = 1.5
        typingAnimation.animation = Animation.named("recentTyping")
        typingAnimation.play()
        typingAnimation.backgroundBehavior = .pauseAndRestore
        typingAnimation.loopMode = .loop
    }
    
    func setupUnreadMessagesView(){
        addSubview(unreadMessageView)
        unreadMessageView.isHidden = true
        unreadMessageView.translatesAutoresizingMaskIntoConstraints = false
        unreadMessageView.backgroundColor = .black
        unreadMessageView.layer.cornerRadius = 10
        unreadMessageView.layer.masksToBounds = true
        unreadMessageView.addSubview(unreadLabel)
        unreadLabel.translatesAutoresizingMaskIntoConstraints = false
        unreadLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        unreadLabel.textColor = .white
        let constraints = [
            unreadMessageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            unreadMessageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            unreadMessageView.widthAnchor.constraint(equalToConstant: 20),
            unreadMessageView.heightAnchor.constraint(equalToConstant: 20),
            unreadLabel.centerXAnchor.constraint(equalTo: unreadMessageView.centerXAnchor),
            unreadLabel.centerYAnchor.constraint(equalTo: unreadMessageView.centerYAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
