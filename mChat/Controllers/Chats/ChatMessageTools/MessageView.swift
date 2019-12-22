//
//  MessageView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class MessageView: UIView{
    
    var cell: ChatCell!
    var message: Messages!
    
    init(frame: CGRect, cell: ChatCell, message: Messages) {
        super.init(frame: frame)
        self.cell = cell
        self.message = message
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
        }else if message.mediaUrl != nil {
            addSubview(setupMsgMedia())
        }
    }
    
    func setupMsgText() -> UILabel {
        let messageView = UILabel()
        messageView.text = message.message
        messageView.numberOfLines = 0
        messageView.backgroundColor = .clear
        messageView.textColor = cell.message.textColor
        addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.font = UIFont(name: "Helvetica Neue", size: 16)
        let constraints = [
            messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageView.topAnchor.constraint(equalTo: topAnchor),
            messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            messageView.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        return messageView
    }
    
    func setupMsgMedia() -> UIImageView{
        let mediaMessage = UIImageView()
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
    
}
