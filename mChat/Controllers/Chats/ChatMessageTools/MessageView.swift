//
//  MessageView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class MessageView: UIView{
    
    var friendName: String!
    var cell: ChatCell!
    var message: Messages!
    let messageView = UILabel()
    let mediaMessage = UIImageView()
    let repLine = UIView()
    let repNameLabel = UILabel()
    let repTextMessage = UILabel()
    let repMediaMessage = UIImageView()
    
    init(frame: CGRect, cell: ChatCell, message: Messages, friendName: String) {
        super.init(frame: frame)
        self.cell = cell
        self.message = message
        self.friendName = friendName
        showMessageMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showMessageMenu(){
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = cell.messageBackground.backgroundColor
        if message.message != nil {
            addSubview(setupMsgText())
            if message.repMediaMessage != nil || message.repMessage != nil{
                setupRepLine()
                self.setupRepName(name: message.repSender)
                if self.message.repMessage != nil {
                    self.setupRepTextMessage(text: self.message.repMessage)
                }else if self.message.repMediaMessage != nil {
                    self.setupRepMediaMessage(self.message.repMediaMessage)
                }
            }
        }else if message.mediaUrl != nil {
            addSubview(setupMsgMedia())
        }
    }
    
    func setupMsgText() -> UILabel {
        messageView.text = message.message
        messageView.numberOfLines = 0
        messageView.backgroundColor = .clear
        messageView.textColor = cell.message.textColor
        addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.font = UIFont(name: "Helvetica Neue", size: 16)
        if message.repMediaMessage != nil || message.repMessage != nil {
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        }else{
            messageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
        let constraints = [
            messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
        return messageView
    }
    
    func setupMsgMedia() -> UIImageView{
        mediaMessage.loadImage(url: message.mediaUrl)
        addSubview(mediaMessage)
        mediaMessage.translatesAutoresizingMaskIntoConstraints = false
        mediaMessage.layer.cornerRadius = 16
        mediaMessage.layer.masksToBounds = true
        mediaMessage.contentMode = .scaleAspectFill
        let constraints = [
            mediaMessage.topAnchor.constraint(equalTo: topAnchor),
            mediaMessage.centerYAnchor.constraint(equalTo: centerYAnchor),
            mediaMessage.widthAnchor.constraint(equalTo: widthAnchor),
            mediaMessage.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        return mediaMessage
    }
    
    func setupRepLine(){
        repLine.backgroundColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
        addSubview(repLine)
        repLine.translatesAutoresizingMaskIntoConstraints = false
        repLine.backgroundColor = cell.repLine.backgroundColor
        let constraints = [
            repLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            repLine.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            repLine.bottomAnchor.constraint(equalTo: messageView.topAnchor, constant: -2),
            repLine.widthAnchor.constraint(equalToConstant: 2)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupRepName(name: String){
        repNameLabel.text = name
        repNameLabel.textColor = cell.repNameLabel.textColor
        repNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
    }
    
    func setupRepTextMessage(text: String){
        repTextMessage.text = text
        repTextMessage.textColor = cell.repTextMessage.textColor
        repTextMessage.font = UIFont(name: "Helvetica Neue", size: 14)
        addSubview(repTextMessage)
        repTextMessage.translatesAutoresizingMaskIntoConstraints = false
        repTextMessage.addSubview(repNameLabel)
        repNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            repTextMessage.leadingAnchor.constraint(equalTo: repLine.leadingAnchor, constant: 8),
            repTextMessage.bottomAnchor.constraint(equalTo: repLine.bottomAnchor, constant: -4),
            repTextMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            repNameLabel.leadingAnchor.constraint(equalTo: repLine.leadingAnchor, constant: 8),
            repNameLabel.topAnchor.constraint(equalTo: repLine.topAnchor, constant: 2),
            repNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupRepMediaMessage(_ url: String){
        let replyMediaLabel = UILabel()
        replyMediaLabel.text = "Image"
        replyMediaLabel.textColor = .lightText
        replyMediaLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        addSubview(repMediaMessage)
        repMediaMessage.translatesAutoresizingMaskIntoConstraints = false
        repMediaMessage.addSubview(repNameLabel)
        repNameLabel.translatesAutoresizingMaskIntoConstraints = false
        repMediaMessage.addSubview(replyMediaLabel)
        replyMediaLabel.translatesAutoresizingMaskIntoConstraints = false
        repMediaMessage.loadImage(url: url)
        let constraints = [
            repMediaMessage.topAnchor.constraint(equalTo: repLine.topAnchor, constant: 2),
            repMediaMessage.bottomAnchor.constraint(equalTo: repLine.bottomAnchor, constant: -2),
            repMediaMessage.widthAnchor.constraint(equalToConstant: 30),
            repMediaMessage.leadingAnchor.constraint(equalTo: repLine.trailingAnchor, constant: 4),
            replyMediaLabel.centerYAnchor.constraint(equalTo: repMediaMessage.centerYAnchor, constant: 8),
            replyMediaLabel.leadingAnchor.constraint(equalTo: repMediaMessage.trailingAnchor, constant: 4),
            repNameLabel.leadingAnchor.constraint(equalTo: repMediaMessage.trailingAnchor, constant: 4),
            repNameLabel.centerYAnchor.constraint(equalTo: repMediaMessage.centerYAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
