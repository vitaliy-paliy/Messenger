//
//  MessageContainer.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/31/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Lottie

class MessageContainer: UIView, UITextViewDelegate{
    
    var bottomAnchr = NSLayoutConstraint()
    var heightAnchr = NSLayoutConstraint()
    let clipImageButton = UIButton(type: .system)
    var sendButton = UIButton(type: .system)
    var micButton = UIButton(type: .system)
    var messageTV = UITextView()
    var recordingAudioView = AnimationView()
    var recordingLabel = UILabel()
    var actionCircle = UIView()
    var height: CGFloat!
    var const: CGFloat!
    var chatVC: ChatVC!
    
    init(height: CGFloat, const: CGFloat, chatVC: ChatVC) {
        super.init(frame: .zero)
        self.chatVC = chatVC
        self.height = height
        self.const = const
        setupMessageContainer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMessageContainer(){
        setupBackground()
        setupImageClipButton()
        setupSendButton()
        setupMicrophone()
        setupMessageTF()
        recordingAudioAnimation()
        setupRecordingLabel()
        setupActionCircle()
    }
    
    func setupBackground(){
        chatVC.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        bottomAnchr = bottomAnchor.constraint(equalTo: chatVC.view.bottomAnchor)
        heightAnchr = heightAnchor.constraint(equalToConstant: height)
        let constraints = [
            leadingAnchor.constraint(equalTo: chatVC.view.leadingAnchor),
            bottomAnchr,
            heightAnchr,
            trailingAnchor.constraint(equalTo: chatVC.view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupImageClipButton(){
        clipImageButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
        addSubview(clipImageButton)
        clipImageButton.tintColor = .black
        clipImageButton.contentMode = .scaleAspectFill
        clipImageButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            clipImageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            clipImageButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -const),
            clipImageButton.widthAnchor.constraint(equalToConstant: 30),
            clipImageButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        clipImageButton.addTarget(chatVC, action: #selector(chatVC.clipImageButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupSendButton(){
        addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.alpha = 0
        sendButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        sendButton.backgroundColor = .black
        sendButton.layer.cornerRadius = 15
        sendButton.layer.masksToBounds = true
        sendButton.tintColor = .white
        let constraints = [
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -const),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
        ]
        NSLayoutConstraint.activate(constraints)
        sendButton.addTarget(chatVC, action: #selector(chatVC.sendButtonPressed), for: .touchUpInside)
    }
    
    func setupMicrophone(){
        addSubview(micButton)
        micButton.translatesAutoresizingMaskIntoConstraints = false
        micButton.setImage(UIImage(systemName: "mic"), for: .normal)
        micButton.tintColor = .black
        micButton.addTarget(chatVC, action: #selector(chatVC.handleAudioRecording), for: .touchUpInside)
        let constraints = [
            micButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -const),
            micButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            micButton.heightAnchor.constraint(equalToConstant: 30),
            micButton.widthAnchor.constraint(equalToConstant: 30),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupMessageTF(){
        addSubview(messageTV)
        messageTV.layer.cornerRadius = 12
        messageTV.font = UIFont(name: "Helvetica Neue", size: 16)
        messageTV.textColor = .black
        messageTV.isScrollEnabled = false
        messageTV.layer.borderWidth = 0.2
        messageTV.layer.borderColor = UIColor.systemGray.cgColor
        messageTV.layer.masksToBounds = true
        let messTFPlaceholder = UILabel()
        messTFPlaceholder.text = "Message"
        messTFPlaceholder.font = UIFont(name: "Helvetica Neue", size: 16)
        messTFPlaceholder.sizeToFit()
        messageTV.addSubview(messTFPlaceholder)
        messTFPlaceholder.frame.origin = CGPoint(x: 10, y: 6)
        messTFPlaceholder.textColor = .lightGray
        messageTV.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 10)
        messageTV.translatesAutoresizingMaskIntoConstraints = false
        messageTV.backgroundColor = UIColor(white: 0.95, alpha: 1)
        messageTV.adjustsFontForContentSizeCategory = true
        messageTV.delegate = self
        let constraints = [
            messageTV.leadingAnchor.constraint(equalTo: clipImageButton.trailingAnchor, constant: 8),
            messageTV.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            messageTV.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -const),
            messageTV.heightAnchor.constraint(equalToConstant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func recordingAudioAnimation(){
        recordingAudioView.isHidden = true
        addSubview(recordingAudioView)
        recordingAudioView.animation = Animation.named("audioWave")
        recordingAudioView.play()
        recordingAudioView.loopMode = .loop
        recordingAudioView.backgroundBehavior = .pauseAndRestore
        recordingAudioView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            recordingAudioView.centerYAnchor.constraint(equalTo: centerYAnchor),
            recordingAudioView.centerXAnchor.constraint(equalTo: centerXAnchor),
            recordingAudioView.heightAnchor.constraint(equalToConstant: 180),
            recordingAudioView.widthAnchor.constraint(equalToConstant: 180)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupRecordingLabel(){
        addSubview(recordingLabel)
        recordingLabel.isHidden = true
        recordingLabel.text = "00:00"
        recordingLabel.translatesAutoresizingMaskIntoConstraints = false
        recordingLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        let constraints = [
            recordingLabel.trailingAnchor.constraint(equalTo: leadingAnchor),
            recordingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -const - 5)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    func setupActionCircle(){
        addSubview(actionCircle)
        actionCircle.isHidden = true
        actionCircle.translatesAutoresizingMaskIntoConstraints = false
        actionCircle.backgroundColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
        actionCircle.layer.cornerRadius = 3
        actionCircle.layer.masksToBounds = true
        let constraints = [
            actionCircle.heightAnchor.constraint(equalToConstant: 6),
            actionCircle.widthAnchor.constraint(equalToConstant: 6),
            actionCircle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            actionCircle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -const - 10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
}

extension MessageContainer {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        chatVC.chatNetworking.disableIsTyping()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        chatVC.chatNetworking.isTypingHandler(tV: textView)
        chatVC.animateActionButton()
        if !messageTV.text.isEmpty {
            messageTV.subviews[2].isHidden = true
        }else{
            messageTV.subviews[2].isHidden = false
        }
        let size = CGSize(width: textView.frame.width, height: 150)
        let estSize = textView.sizeThatFits(size)
        messageTV.constraints.forEach { (constraint) in
            if constraint.firstAttribute != .height { return }
            chatVC.messageHeightHandler(constraint, estSize)
            chatVC.messageContainerHeightHandler(heightAnchr, estSize)
        }
    }
}
