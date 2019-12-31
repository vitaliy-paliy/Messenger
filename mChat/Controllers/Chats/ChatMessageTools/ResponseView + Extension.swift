//
//  ResponseView + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/30/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

extension ChatVC {
    
    func responseViewChangeAlpha(a: CGFloat){
        userResponse.lineView.alpha = a
        userResponse.nameLabel.alpha = a
        userResponse.messageLabel.alpha = a
        userResponse.mediaMessage.alpha = a
        userResponse.exitButton.alpha = a
    }
    
    func responseMessageLine(_ message: Messages, _ fN: String?){
        userResponse.lineView.backgroundColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
        userResponse.lineView.layer.cornerRadius = 1
        userResponse.lineView.layer.masksToBounds = true
        messageContainer.addSubview(userResponse.lineView)
        userResponse.lineView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            userResponse.lineView.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 8),
            userResponse.lineView.bottomAnchor.constraint(equalTo: messageTV.topAnchor, constant: -8),
            userResponse.lineView.leadingAnchor.constraint(equalTo: messageTV.leadingAnchor, constant: 8),
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
    
    func setupExitResponseButton(){
        messageContainer.addSubview(userResponse.exitButton)
        userResponse.exitButton.translatesAutoresizingMaskIntoConstraints = false
        userResponse.exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        userResponse.exitButton.tintColor = .black
        let constraints = [
            userResponse.exitButton.trailingAnchor.constraint(equalTo: messageTV.trailingAnchor, constant: -16),
            userResponse.exitButton.centerYAnchor.constraint(equalTo: userResponse.lineView.centerYAnchor),
            userResponse.exitButton.widthAnchor.constraint(equalToConstant: 14),
            userResponse.exitButton.heightAnchor.constraint(equalToConstant: 14)
        ]
        userResponse.exitButton.addTarget(self, action: #selector(exitResponseButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func exitResponseButtonPressed(){
        userResponse.responseStatus = false
        userResponse.repliedMessage = nil
        userResponse.messageToForward = nil
        userResponse.messageSender = nil
        containterHAnchor.constant -= 50
        UIView.animate(withDuration: 0.3){
            self.userResponse.lineView.removeFromSuperview()
            self.userResponse.exitButton.removeFromSuperview()
            self.userResponse.nameLabel.removeFromSuperview()
            self.userResponse.mediaMessage.removeFromSuperview()
            self.userResponse.messageLabel.removeFromSuperview()
        }
        
    }
    
    func responseMessageName(for message: Messages, _ name: String){
        userResponse.messageSender = name
        messageContainer.addSubview(userResponse.nameLabel)
        userResponse.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        userResponse.nameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        userResponse.nameLabel.textColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
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
    
    func setupResponseMessage(_ message: Messages){
        if message.mediaUrl == nil {
            setupResponseTextM(message)
        }else{
            setupResponseMediaM(message)
        }
    }
    
    func setupResponseTextM(_ message: Messages){
        messageContainer.addSubview(userResponse.messageLabel)
        userResponse.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        userResponse.messageLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        userResponse.messageLabel.textColor = .black
        userResponse.messageLabel.text = message.message
        let constraints = [
            userResponse.messageLabel.leadingAnchor.constraint(equalTo: userResponse.lineView.trailingAnchor, constant: 8),
            userResponse.messageLabel.trailingAnchor.constraint(equalTo: userResponse.exitButton.trailingAnchor, constant: -16),
            userResponse.messageLabel.topAnchor.constraint(equalTo: userResponse.nameLabel.bottomAnchor, constant: -2),
            userResponse.messageLabel.bottomAnchor.constraint(equalTo: messageTV.topAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupResponseMediaM(_ message: Messages){
        let replyMediaLabel = UILabel()
        replyMediaLabel.text = "Image"
        replyMediaLabel.textColor = .gray
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
            userResponse.mediaMessage.leadingAnchor.constraint(equalTo: userResponse.lineView.trailingAnchor, constant: 8),
            replyMediaLabel.centerYAnchor.constraint(equalTo: userResponse.mediaMessage.centerYAnchor, constant: 8),
            replyMediaLabel.leadingAnchor.constraint(equalTo: userResponse.mediaMessage.trailingAnchor, constant: 4),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func showResponseMessageView(cell: ChatCell){
        var index = 0
        for message in messages {
            if message.id == cell.msg.repMID {
                let indexPath = IndexPath(row: index, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                break
            }
            index += 1
        }
    }
    
}
