//
//  ChatCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/22/19.
//  Copyright © 2019 PALIY. All rights reserved.
//
import UIKit

class ChatCell: UICollectionViewCell {
    
    var msg: Messages!
    var message = UILabel()
    var messageBackground = UIView()
    var mediaMessage = UIImageView()
    var chatVC: ChatVC!
    var msgTopAnchor: NSLayoutConstraint!
    var replyMsgTopAnchor: NSLayoutConstraint!
    var backgroundWidthAnchor: NSLayoutConstraint!
    var outcomingMessage: NSLayoutConstraint!
    var incomingMessage: NSLayoutConstraint!
    var isIncoming: Bool! {
        didSet{
            messageBackground.backgroundColor = isIncoming ?  .white  : UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
            message.textColor = isIncoming ? .black : .white
            let replyColor = isIncoming ? UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1) : .white
            replyLine.backgroundColor = replyColor
            replyNameLabel.textColor = replyColor
            replyTextMessage.textColor = replyColor
        }
    }
    
    // Reply Outlets
    let replyView = UIView()
    let replyLine = UIView()
    let replyNameLabel = UILabel()
    let replyTextMessage = UILabel()
    let replyMediaMessage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(messageBackground)
        setupBackgroundView()
        setupMessage()
        setupMediaMessage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackgroundView(){
        messageBackground.translatesAutoresizingMaskIntoConstraints = false
        messageBackground.layer.cornerRadius = 12
        messageBackground.layer.masksToBounds = true
        backgroundWidthAnchor = messageBackground.widthAnchor.constraint(equalToConstant: 200)
        let constraints = [
            messageBackground.topAnchor.constraint(equalTo: topAnchor),
            backgroundWidthAnchor!,
            messageBackground.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        outcomingMessage = messageBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        incomingMessage = messageBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        outcomingMessage.isActive = true
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupMessage(){
        messageBackground.addSubview(message)
        message.numberOfLines = 0
        message.backgroundColor = .clear
        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = UIFont(name: "Helvetica Neue", size: 16)
        msgTopAnchor = message.topAnchor.constraint(equalTo: messageBackground.topAnchor)
        replyMsgTopAnchor = message.topAnchor.constraint(equalTo: messageBackground.topAnchor, constant: 50)
        let constraints = [
            message.leadingAnchor.constraint(equalTo: messageBackground.leadingAnchor, constant: 16),
            message.bottomAnchor.constraint(equalTo: messageBackground.bottomAnchor),
            message.trailingAnchor.constraint(equalTo: messageBackground.trailingAnchor, constant: -8),
            msgTopAnchor!,
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupMediaMessage(){
        messageBackground.addSubview(mediaMessage)
        mediaMessage.translatesAutoresizingMaskIntoConstraints = false
        mediaMessage.layer.cornerRadius = 16
        mediaMessage.layer.masksToBounds = true
        mediaMessage.contentMode = .scaleAspectFill
        let imageTapped = UITapGestureRecognizer(target: self, action: #selector(imageTappedHandler(tap:)))
        mediaMessage.addGestureRecognizer(imageTapped)
        mediaMessage.isUserInteractionEnabled = true
        let constraints = [
            mediaMessage.topAnchor.constraint(equalTo: topAnchor),
            mediaMessage.centerYAnchor.constraint(equalTo: messageBackground.centerYAnchor),
            mediaMessage.widthAnchor.constraint(equalTo: messageBackground.widthAnchor),
            mediaMessage.heightAnchor.constraint(equalTo: messageBackground.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func imageTappedHandler(tap: UITapGestureRecognizer){
        let imageView = tap.view as? UIImageView
        chatVC.zoomImageHandler(image: imageView!)
    }
    
    func setupReplyView(){
        addSubview(replyView)
        replyView.translatesAutoresizingMaskIntoConstraints = false
        replyView.backgroundColor = .clear
        let constraints = [
            replyView.leadingAnchor.constraint(equalTo: messageBackground.leadingAnchor, constant: 16),
            replyView.topAnchor.constraint(equalTo: messageBackground.topAnchor, constant: 8),
            replyView.bottomAnchor.constraint(equalTo: message.topAnchor, constant: -2),
            replyView.trailingAnchor.constraint(equalTo: messageBackground.trailingAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(replyViewTapped))
        replyView.addGestureRecognizer(tapGesture)
    }
    
    func setupRepMessageView(for repMessage: Messages, _ friendName: String){
        guard let name = repMessage.determineUser() == CurrentUser.uid ? CurrentUser.name : friendName else { return }
        msgTopAnchor.isActive = false
        replyMsgTopAnchor.isActive = true
        if backgroundWidthAnchor.constant < 140 { backgroundWidthAnchor.constant = 140 }
        setupReplyLine()
        setupReplyName(name: name)
        if repMessage.repMessage != nil {
            replyMediaMessage.removeFromSuperview()
            setupReplyTextMessage(text: repMessage.repMessage)
        }else if repMessage.repMediaMessage != nil {
            replyTextMessage.removeFromSuperview()
            setupReplyMediaMessage(repMessage.repMediaMessage)
        }
        setupReplyView()
    }
    
    private func setupReplyLine(){
        messageBackground.addSubview(replyLine)
        replyLine.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            replyLine.leadingAnchor.constraint(equalTo: messageBackground.leadingAnchor, constant: 16),
            replyLine.topAnchor.constraint(equalTo: messageBackground.topAnchor, constant: 8),
            replyLine.bottomAnchor.constraint(equalTo: message.topAnchor, constant: -2),
            replyLine.widthAnchor.constraint(equalToConstant: 2)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupReplyName(name: String){
        replyNameLabel.text = name
        replyNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
    }
    
    private func setupReplyTextMessage(text: String){
        replyTextMessage.text = text
        replyTextMessage.font = UIFont(name: "Helvetica Neue", size: 14)
        messageBackground.addSubview(replyTextMessage)
        replyTextMessage.translatesAutoresizingMaskIntoConstraints = false
        replyTextMessage.addSubview(replyNameLabel)
        replyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            replyTextMessage.leadingAnchor.constraint(equalTo: replyLine.leadingAnchor, constant: 8),
            replyTextMessage.bottomAnchor.constraint(equalTo: replyLine.bottomAnchor, constant: -4),
            replyTextMessage.trailingAnchor.constraint(equalTo: messageBackground.trailingAnchor, constant: -8),
            replyNameLabel.leadingAnchor.constraint(equalTo: replyLine.leadingAnchor, constant: 8),
            replyNameLabel.topAnchor.constraint(equalTo: replyLine.topAnchor, constant: 2),
            replyNameLabel.trailingAnchor.constraint(equalTo: messageBackground.trailingAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupReplyMediaMessage(_ url: String){
        let replyMediaLabel = UILabel()
        replyMediaLabel.text = "Image"
        replyMediaLabel.textColor = .lightText
        replyMediaLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        messageBackground.addSubview(replyMediaMessage)
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
    
    func removeReplyOutlets(){
        replyMsgTopAnchor.isActive = false
        replyLine.removeFromSuperview()
        replyNameLabel.removeFromSuperview()
        replyTextMessage.removeFromSuperview()
        replyMediaMessage.removeFromSuperview()
        replyView.removeFromSuperview()
        msgTopAnchor.isActive = true
    }
    
    @objc func replyViewTapped(){
        chatVC.showReplyMessageView(cell: self)
    }
    
}
