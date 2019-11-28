//
//  ChatCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/22/19.
//  Copyright © 2019 PALIY. All rights reserved.
//
import UIKit

class ChatCell: UICollectionViewCell {
    
    
    var message = UILabel()
    var messageBackground = UIView()
    var mediaMessage = UIImageView()
    var viewImage = UIView()
    var viewImageLabel = UILabel()
    
    var chatVC: ChatVC!
    var backgroundWidthAnchor: NSLayoutConstraint!
    var outcomingMessage: NSLayoutConstraint!
    var incomingMessage: NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(messageBackground)
        addSubview(message)
        messageBackground.addSubview(mediaMessage)
        mediaMessage.addSubview(viewImage)
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
            messageBackground.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        outcomingMessage = messageBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        incomingMessage = messageBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        outcomingMessage.isActive = true
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupMessage(){
        message.numberOfLines = 0
        message.backgroundColor = .clear
        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = UIFont(name: "Helvetica Neue", size: 16)
        let constraints = [
            message.leadingAnchor.constraint(equalTo: messageBackground.leadingAnchor, constant: 16),
            message.topAnchor.constraint(equalTo: topAnchor),
            message.trailingAnchor.constraint(equalTo: messageBackground.trailingAnchor, constant: -8),
            message.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupMediaMessage(){
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
        setupViewImage()
    }

    func setupViewImage(){
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        viewImage.backgroundColor = .black
        viewImage.alpha = 0.5
        viewImage.addSubview(viewImageLabel)
        viewImageLabel.translatesAutoresizingMaskIntoConstraints = false
        viewImageLabel.text = "View"
        viewImageLabel.textColor = .white
        viewImageLabel.textAlignment = .center
        viewImageLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        let constraints = [
            viewImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewImage.heightAnchor.constraint(equalToConstant: 25),
            viewImage.widthAnchor.constraint(equalTo: widthAnchor),
            viewImageLabel.centerXAnchor.constraint(equalTo: messageBackground.centerXAnchor),
        
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc func imageTappedHandler(tap: UITapGestureRecognizer){
        let imageView = tap.view as? UIImageView
        chatVC.zoomImageHandler(image: imageView!)
    }
    
}
