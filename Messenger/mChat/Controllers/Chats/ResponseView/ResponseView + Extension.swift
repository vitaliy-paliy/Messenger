//
//  ResponseView + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/30/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

extension ChatVC {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func responseViewChangeAlpha(a: CGFloat){
        userResponse.lineView.alpha = a
        userResponse.nameLabel.alpha = a
        userResponse.messageLabel.alpha = a
        userResponse.mediaMessage.alpha = a
        userResponse.exitButton.alpha = a
        userResponse.audioMessage.alpha = a
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func responseMessageLine(_ message: Messages, _ fN: String?){
        userResponse.lineView.backgroundColor = ThemeColors.selectedOutcomingColor
        userResponse.lineView.layer.cornerRadius = 1
        userResponse.lineView.layer.masksToBounds = true
        messageContainer.addSubview(userResponse.lineView)
        userResponse.lineView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            userResponse.lineView.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 8),
            userResponse.lineView.bottomAnchor.constraint(equalTo: messageContainer.messageTV.topAnchor, constant: -8),
            userResponse.lineView.leadingAnchor.constraint(equalTo: messageContainer.messageTV.leadingAnchor, constant: 8),
            userResponse.lineView.widthAnchor.constraint(equalToConstant: 2),
        ]
        NSLayoutConstraint.activate(constraints)
        setupExitResponseButton()
        if let fN = fN {
            responseMessageName(for: message, fN)
        }else{
            chatNetworking.getMessageSender(message: message) { (sender) in
                self.responseMessageName(for: message, sender)
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupExitResponseButton(){
        messageContainer.addSubview(userResponse.exitButton)
        userResponse.exitButton.translatesAutoresizingMaskIntoConstraints = false
        userResponse.exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        userResponse.exitButton.tintColor = .black
        let constraints = [
            userResponse.exitButton.trailingAnchor.constraint(equalTo: messageContainer.messageTV.trailingAnchor, constant: -16),
            userResponse.exitButton.centerYAnchor.constraint(equalTo: userResponse.lineView.centerYAnchor),
            userResponse.exitButton.widthAnchor.constraint(equalToConstant: 14),
            userResponse.exitButton.heightAnchor.constraint(equalToConstant: 14)
        ]
        userResponse.exitButton.addTarget(self, action: #selector(exitResponseButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func exitResponseButtonPressed(){
        userResponse.responseStatus = false
        userResponse.repliedMessage = nil
        userResponse.messageToForward = nil
        userResponse.messageSender = nil
        messageContainer.heightAnchr.constant -= 50
        messageContainer.micButton.alpha = 1
        messageContainer.sendButton.alpha = 0
        UIView.animate(withDuration: 0.3){
            self.userResponse.lineView.removeFromSuperview()
            self.userResponse.exitButton.removeFromSuperview()
            self.userResponse.nameLabel.removeFromSuperview()
            self.userResponse.mediaMessage.removeFromSuperview()
            self.userResponse.messageLabel.removeFromSuperview()
            self.userResponse.audioMessage.removeFromSuperview()
        }
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func responseMessageName(for message: Messages, _ name: String){
        userResponse.messageSender = name
        messageContainer.addSubview(userResponse.nameLabel)
        userResponse.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        userResponse.nameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        userResponse.nameLabel.textColor = ThemeColors.selectedOutcomingColor
        userResponse.nameLabel.text = name
        userResponse.nameLabelConstraint = userResponse.nameLabel.leadingAnchor.constraint(equalTo: userResponse.lineView.trailingAnchor, constant: 8)
        let constraints = [
            userResponse.nameLabelConstraint!,
            userResponse.nameLabel.trailingAnchor.constraint(equalTo: userResponse.exitButton.trailingAnchor, constant: -8),
            userResponse.nameLabel.topAnchor.constraint(equalTo: userResponse.lineView.topAnchor, constant: 4)
        ]
        NSLayoutConstraint.activate(constraints)
        setupResponseMessage(message)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupResponseMessage(_ message: Messages){
        if message.mediaUrl != nil {
            setupResponseMediaM(message)
        }else if message.audioUrl != nil {
            setupAudioMessage()
        }else{
            setupResponseTextM(message)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupResponseTextM(_ message: Messages){
        messageContainer.addSubview(userResponse.messageLabel)
        userResponse.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        userResponse.messageLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        userResponse.messageLabel.textColor = .black
        userResponse.messageLabel.text = message.message
        let constraints = [
            userResponse.messageLabel.leadingAnchor.constraint(equalTo: userResponse.lineView.trailingAnchor, constant: 8),
            userResponse.messageLabel.trailingAnchor.constraint(equalTo: userResponse.exitButton.trailingAnchor, constant: -16),
            userResponse.messageLabel.topAnchor.constraint(equalTo: userResponse.nameLabel.bottomAnchor),
            userResponse.messageLabel.bottomAnchor.constraint(equalTo: messageContainer.messageTV.topAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupResponseMediaM(_ message: Messages){
        let replyMediaLabel = UILabel()
        replyMediaLabel.text = "Media"
        replyMediaLabel.textColor = .lightGray
        replyMediaLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        messageContainer.addSubview(userResponse.mediaMessage)
        userResponse.mediaMessage.translatesAutoresizingMaskIntoConstraints = false
        userResponse.mediaMessage.addSubview(replyMediaLabel)
        replyMediaLabel.translatesAutoresizingMaskIntoConstraints = false
        userResponse.mediaMessage.loadImage(url: message.mediaUrl)
        userResponse.nameLabelConstraint.constant += 34
        let constraints = [
            userResponse.mediaMessage.topAnchor.constraint(equalTo: userResponse.lineView.topAnchor, constant: 2),
            userResponse.mediaMessage.bottomAnchor.constraint(equalTo: userResponse.lineView.bottomAnchor, constant: -2),
            userResponse.mediaMessage.widthAnchor.constraint(equalToConstant: 30),
            userResponse.mediaMessage.leadingAnchor.constraint(equalTo: userResponse.lineView.trailingAnchor, constant: 4),
            replyMediaLabel.centerYAnchor.constraint(equalTo: userResponse.mediaMessage.centerYAnchor, constant: 8),
            replyMediaLabel.leadingAnchor.constraint(equalTo: userResponse.mediaMessage.trailingAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupAudioMessage(){
        messageContainer.addSubview(userResponse.audioMessage)
        userResponse.audioMessage.translatesAutoresizingMaskIntoConstraints = false
        userResponse.audioMessage.text = "Audio Message"
        userResponse.audioMessage.textColor = .lightGray
        userResponse.audioMessage.font = UIFont(name: "Helvetica Neue", size: 15)
        let constraints = [
            userResponse.audioMessage.leadingAnchor.constraint(equalTo: userResponse.lineView.trailingAnchor, constant: 8),
            userResponse.audioMessage.trailingAnchor.constraint(equalTo: userResponse.exitButton.trailingAnchor, constant: -16),
            userResponse.audioMessage.topAnchor.constraint(equalTo: userResponse.nameLabel.bottomAnchor, constant: -2),
            userResponse.audioMessage.bottomAnchor.constraint(equalTo: messageContainer.messageTV.topAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
