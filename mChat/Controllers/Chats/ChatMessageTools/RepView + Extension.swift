//
//  RepView + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/30/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

extension ChatVC {
    func repButtonPressed(_ message: Messages, forwardedName: String? = nil){
        repViewChangeAlpha(a: 0)
        messageTV.becomeFirstResponder()
        repStatus = true
        repliedMessage = message
        containterHAnchor.constant += 50
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            self.repMessageLine(message, forwardedName)
        }) { (true) in
            self.repViewChangeAlpha(a: 1)
        }
    }
    
    func repViewChangeAlpha(a: CGFloat){
        repLine.alpha = a
        repNameLabel.alpha = a
        repMessageLabel.alpha = a
        repMediaMessage.alpha = a
        exitRepButton.alpha = a
    }
    
    func repMessageLine(_ message: Messages, _ fN: String?){
        repLine.backgroundColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
        repLine.layer.cornerRadius = 1
        repLine.layer.masksToBounds = true
        messageContainer.addSubview(repLine)
        repLine.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            repLine.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 8),
            repLine.bottomAnchor.constraint(equalTo: messageTV.topAnchor, constant: -8),
            repLine.leadingAnchor.constraint(equalTo: messageTV.leadingAnchor, constant: 8),
            repLine.widthAnchor.constraint(equalToConstant: 2),
        ]
        NSLayoutConstraint.activate(constraints)
        setupExitRepButton()
        if let fN = fN {
            repMessageName(for: message, fN)
        }else{
            chatNetworking.getMessageSender(message: message) { (sender) in
                self.repMessageName(for: message, sender)
            }
        }
    }
    
    func setupExitRepButton(){
        messageContainer.addSubview(exitRepButton)
        exitRepButton.translatesAutoresizingMaskIntoConstraints = false
        exitRepButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        exitRepButton.tintColor = .black
        let constraints = [
            exitRepButton.trailingAnchor.constraint(equalTo: messageTV.trailingAnchor, constant: -16),
            exitRepButton.centerYAnchor.constraint(equalTo: repLine.centerYAnchor),
            exitRepButton.widthAnchor.constraint(equalToConstant: 14),
            exitRepButton.heightAnchor.constraint(equalToConstant: 14)
        ]
        exitRepButton.addTarget(self, action: #selector(exitRepButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func exitRepButtonPressed(){
        repStatus = false
        repliedMessage = nil
        messageToForward = nil
        messageSender = nil
        self.containterHAnchor.constant -= 50
        UIView.animate(withDuration: 0.3){
            self.repLine.removeFromSuperview()
            self.exitRepButton.removeFromSuperview()
            self.repNameLabel.removeFromSuperview()
            self.repMediaMessage.removeFromSuperview()
            self.repMessageLabel.removeFromSuperview()
        }
        
    }
    
    func repMessageName(for message: Messages, _ name: String){
        messageSender = name
        messageContainer.addSubview(repNameLabel)
        repNameLabel.translatesAutoresizingMaskIntoConstraints = false
        repNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        repNameLabel.textColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
        repNameLabel.text = name
        repNameLabelConstraint = repNameLabel.leadingAnchor.constraint(equalTo: repLine.trailingAnchor, constant: 8)
        let constraints = [
            repNameLabelConstraint!,
            repNameLabel.trailingAnchor.constraint(equalTo: exitRepButton.trailingAnchor, constant: -8),
            repNameLabel.topAnchor.constraint(equalTo: repLine.topAnchor, constant: 4)
        ]
        NSLayoutConstraint.activate(constraints)
        setupRepMessage(message)
    }
    
    func setupRepMessage(_ message: Messages){
        if message.mediaUrl == nil {
            setupRepTextM(message)
        }else{
            setupRepMediaM(message)
        }
    }
    
    func setupRepTextM(_ message: Messages){
        messageContainer.addSubview(repMessageLabel)
        repMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        repMessageLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        repMessageLabel.textColor = .black
        repMessageLabel.text = message.message
        let constraints = [
            repMessageLabel.leadingAnchor.constraint(equalTo: repLine.trailingAnchor, constant: 8),
            repMessageLabel.trailingAnchor.constraint(equalTo: exitRepButton.trailingAnchor, constant: -16),
            repMessageLabel.topAnchor.constraint(equalTo: repNameLabel.bottomAnchor, constant: -2),
            repMessageLabel.bottomAnchor.constraint(equalTo: messageTV.topAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupRepMediaM(_ message: Messages){
        let replyMediaLabel = UILabel()
        replyMediaLabel.text = "Image"
        replyMediaLabel.textColor = .gray
        replyMediaLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        messageContainer.addSubview(repMediaMessage)
        repMediaMessage.translatesAutoresizingMaskIntoConstraints = false
        repMediaMessage.addSubview(replyMediaLabel)
        replyMediaLabel.translatesAutoresizingMaskIntoConstraints = false
        repMediaMessage.loadImage(url: message.mediaUrl)
        repNameLabelConstraint.constant += 34
        let constraints = [
            repMediaMessage.topAnchor.constraint(equalTo: repLine.topAnchor, constant: 2),
            repMediaMessage.bottomAnchor.constraint(equalTo: repLine.bottomAnchor, constant: -2),
            repMediaMessage.widthAnchor.constraint(equalToConstant: 30),
            repMediaMessage.leadingAnchor.constraint(equalTo: repLine.trailingAnchor, constant: 8),
            replyMediaLabel.centerYAnchor.constraint(equalTo: repMediaMessage.centerYAnchor, constant: 8),
            replyMediaLabel.leadingAnchor.constraint(equalTo: repMediaMessage.trailingAnchor, constant: 4),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func showRepMessageView(cell: ChatCell){
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
    
    func forwardButtonPressed(_ message: Messages) {
        chatNetworking.getMessageSender(message: message) { (name) in
            self.messageToForward = message
            let convController = NewConversationVC()
            convController.delegate = self
            convController.forwardName = name
            let navController = UINavigationController(rootViewController: convController)
            self.present(navController, animated: true, completion: nil)
        }
    }
}
