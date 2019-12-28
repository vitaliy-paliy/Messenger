//
//  MessageView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class MessageView: UIView{
    
    var friendName: String!
    var cell: ChatCell!
    var message: Messages!
    let messageView = UILabel()
    let mediaMessage = UIImageView()
    let replyLine = UIView()
    let replyNameLabel = UILabel()
    let replyTextMessage = UILabel()
    let replyMediaMessage = UIImageView()
    
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
                setupReplyLine()
                guard let name = message.determineUser() == CurrentUser.uid ? CurrentUser.name : friendName else { return }
                setupReplyName(name: name)
                if message.repMessage != nil {
                    setupReplyTextMessage(text: message.repMessage)
                }else if message.repMediaMessage != nil {
                    setupReplyMediaMessage(message.repMediaMessage)
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
    
    func setupReplyLine(){
        replyLine.backgroundColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
        addSubview(replyLine)
        replyLine.translatesAutoresizingMaskIntoConstraints = false
        replyLine.backgroundColor = cell.replyLine.backgroundColor
        let constraints = [
            replyLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            replyLine.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            replyLine.bottomAnchor.constraint(equalTo: messageView.topAnchor, constant: -2),
            replyLine.widthAnchor.constraint(equalToConstant: 2)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupReplyName(name: String){
        replyNameLabel.text = name
        replyNameLabel.textColor = cell.replyNameLabel.textColor
        replyNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
    }
    
    func setupReplyTextMessage(text: String){
        replyTextMessage.text = text
        replyTextMessage.textColor = cell.replyTextMessage.textColor
        replyTextMessage.font = UIFont(name: "Helvetica Neue", size: 14)
        addSubview(replyTextMessage)
        replyTextMessage.translatesAutoresizingMaskIntoConstraints = false
        replyTextMessage.addSubview(replyNameLabel)
        replyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            replyTextMessage.leadingAnchor.constraint(equalTo: replyLine.leadingAnchor, constant: 8),
            replyTextMessage.bottomAnchor.constraint(equalTo: replyLine.bottomAnchor, constant: -4),
            replyTextMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            replyNameLabel.leadingAnchor.constraint(equalTo: replyLine.leadingAnchor, constant: 8),
            replyNameLabel.topAnchor.constraint(equalTo: replyLine.topAnchor, constant: 2),
            replyNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupReplyMediaMessage(_ url: String){
        let replyMediaLabel = UILabel()
        replyMediaLabel.text = "Image"
        replyMediaLabel.textColor = .lightText
        replyMediaLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        addSubview(replyMediaMessage)
        replyMediaMessage.translatesAutoresizingMaskIntoConstraints = false
        replyMediaMessage.addSubview(replyNameLabel)
        replyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        replyMediaMessage.addSubview(replyMediaLabel)
        replyMediaLabel.translatesAutoresizingMaskIntoConstraints = false
        replyMediaMessage.loadImage(url: url)
        let constraints = [
            replyMediaMessage.topAnchor.constraint(equalTo: replyLine.topAnchor, constant: 2),
            replyMediaMessage.bottomAnchor.constraint(equalTo: replyLine.bottomAnchor, constant: -2),
            replyMediaMessage.widthAnchor.constraint(equalToConstant: 30),
            replyMediaMessage.leadingAnchor.constraint(equalTo: replyLine.trailingAnchor, constant: 4),
            replyMediaLabel.centerYAnchor.constraint(equalTo: replyMediaMessage.centerYAnchor, constant: 8),
            replyMediaLabel.leadingAnchor.constraint(equalTo: replyMediaMessage.trailingAnchor, constant: 4),
            replyNameLabel.leadingAnchor.constraint(equalTo: replyMediaMessage.trailingAnchor, constant: 4),
            replyNameLabel.centerYAnchor.constraint(equalTo: replyMediaMessage.centerYAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
