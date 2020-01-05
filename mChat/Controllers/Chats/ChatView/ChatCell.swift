//
//  ChatCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/22/19.
//  Copyright © 2019 PALIY. All rights reserved.
//
import UIKit
import AVFoundation

class ChatCell: UICollectionViewCell {
    
    var msg: Messages?
    var message = UILabel()
    var messageBackground = UIView()
    var mediaMessage = UIImageView()
    var chatVC: ChatVC!
    var msgTopAnchor: NSLayoutConstraint!
    var replyMsgTopAnchor: NSLayoutConstraint!
    var backgroundWidthAnchor: NSLayoutConstraint!
    var outcomingMessage: NSLayoutConstraint!
    var incomingMessage: NSLayoutConstraint!
    
    var audioPlayButton = UIButton(type: .system)
    var durationLabel = UILabel()
    var audioPlayer: AVAudioPlayer!
    var timer: Timer!
    
    var isIncoming: Bool! {
        didSet{
            messageBackground.backgroundColor = isIncoming ?  .white  : UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
            message.textColor = isIncoming ? .black : .white
            let userColor = isIncoming ? UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1) : .white
            repLine.backgroundColor = userColor
            repNameLabel.textColor = userColor
            repTextMessage.textColor = userColor
            audioPlayButton.tintColor = userColor
            durationLabel.textColor = userColor
        }
    }
    
    // Reply Outlets
    let repView = UIView()
    let repLine = UIView()
    let repNameLabel = UILabel()
    let repTextMessage = UILabel()
    let repMediaMessage = UIImageView()
    let responseAudioMessage = UILabel()
    
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
    
    private func setupBackgroundView(){
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
    
    private func setupMessage(){
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
    
    private func setupMediaMessage(){
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
    
    @objc private func imageTappedHandler(tap: UITapGestureRecognizer){
        let imageView = tap.view as? UIImageView
        chatVC.zoomImageHandler(image: imageView!)
    }
    
    private func setupReplyView(){
        addSubview(repView)
        repView.translatesAutoresizingMaskIntoConstraints = false
        repView.backgroundColor = .clear
        let constraints = [
            repView.leadingAnchor.constraint(equalTo: messageBackground.leadingAnchor, constant: 16),
            repView.topAnchor.constraint(equalTo: messageBackground.topAnchor, constant: 8),
            repView.bottomAnchor.constraint(equalTo: message.topAnchor, constant: -2),
            repView.trailingAnchor.constraint(equalTo: messageBackground.trailingAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(replyViewTapped))
        repView.addGestureRecognizer(tapGesture)
    }
    
    func setupRepMessageView(_ friendName: String){
        self.handleRepMessageSetup(friendName)
    }
    
    private func handleRepMessageSetup(_ name: String){
        self.msgTopAnchor.isActive = false
        self.replyMsgTopAnchor.isActive = true
        if self.backgroundWidthAnchor.constant < 140 { self.backgroundWidthAnchor.constant = 140 }
        self.setupReplyLine()
        self.setupReplyName(name: name)
        if msg?.repMessage != nil {
            self.repMediaMessage.removeFromSuperview()
            self.responseAudioMessage.removeFromSuperview()
            self.setupReplyTextMessage(text: msg!.repMessage)
        }else if msg?.repMediaMessage != nil {
            self.repTextMessage.removeFromSuperview()
            self.responseAudioMessage.removeFromSuperview()
            self.setupReplyMediaMessage(msg!.repMediaMessage)
        }else{
            self.repMediaMessage.removeFromSuperview()
            self.repTextMessage.removeFromSuperview()
            setupResponseAudioMessage()
        }
        self.setupReplyView()
    }
    
    private func setupReplyLine(){
        messageBackground.addSubview(repLine)
        repLine.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            repLine.leadingAnchor.constraint(equalTo: messageBackground.leadingAnchor, constant: 16),
            repLine.topAnchor.constraint(equalTo: messageBackground.topAnchor, constant: 8),
            repLine.bottomAnchor.constraint(equalTo: message.topAnchor, constant: -2),
            repLine.widthAnchor.constraint(equalToConstant: 2)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupReplyName(name: String){
        repNameLabel.text = name
        repNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
    }
    
    private func setupReplyTextMessage(text: String){
        repTextMessage.text = text
        repTextMessage.font = UIFont(name: "Helvetica Neue", size: 15)
        messageBackground.addSubview(repTextMessage)
        repTextMessage.translatesAutoresizingMaskIntoConstraints = false
        repTextMessage.addSubview(repNameLabel)
        repNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            repTextMessage.leadingAnchor.constraint(equalTo: repLine.leadingAnchor, constant: 8),
            repTextMessage.bottomAnchor.constraint(equalTo: repLine.bottomAnchor, constant: -4),
            repTextMessage.trailingAnchor.constraint(equalTo: messageBackground.trailingAnchor, constant: -8),
            repNameLabel.leadingAnchor.constraint(equalTo: repLine.leadingAnchor, constant: 8),
            repNameLabel.topAnchor.constraint(equalTo: repLine.topAnchor, constant: 2),
            repNameLabel.trailingAnchor.constraint(equalTo: messageBackground.trailingAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupReplyMediaMessage(_ url: String){
        let replyMediaLabel = UILabel()
        replyMediaLabel.text = "Image"
        replyMediaLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        replyMediaLabel.textColor = isIncoming ? .lightGray : .lightText
        messageBackground.addSubview(repMediaMessage)
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
    
    private func setupResponseAudioMessage(){
        messageBackground.addSubview(responseAudioMessage)
        responseAudioMessage.translatesAutoresizingMaskIntoConstraints = false
        responseAudioMessage.addSubview(repNameLabel)
        repNameLabel.translatesAutoresizingMaskIntoConstraints = false
        responseAudioMessage.text = "Audio Message"
        responseAudioMessage.textColor = isIncoming ? .lightGray : .lightText
        responseAudioMessage.font = UIFont(name: "Helvetica Neue", size: 15)
        let constraints = [
            repNameLabel.leadingAnchor.constraint(equalTo: repLine.leadingAnchor, constant: 8),
            repNameLabel.topAnchor.constraint(equalTo: repLine.topAnchor, constant: 2),
            repNameLabel.trailingAnchor.constraint(equalTo: messageBackground.trailingAnchor, constant: 8),
            responseAudioMessage.topAnchor.constraint(equalTo: repNameLabel.bottomAnchor, constant: -2),
            responseAudioMessage.leadingAnchor.constraint(equalTo: repLine.leadingAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func removeReplyOutlets(){
        replyMsgTopAnchor.isActive = false
        repLine.removeFromSuperview()
        repNameLabel.removeFromSuperview()
        responseAudioMessage.removeFromSuperview()
        repTextMessage.removeFromSuperview()
        repMediaMessage.removeFromSuperview()
        repView.removeFromSuperview()
        msgTopAnchor.isActive = true
    }
    
    @objc func replyViewTapped(){
        chatVC.showResponseMessageView(cell: self)
    }
    
    func setupAudioPlayButton(){
        audioPlayButton.isEnabled = false
        messageBackground.addSubview(audioPlayButton)
        audioPlayButton.addTarget(self, action: #selector(playAudioButtonPressed), for: .touchUpInside)
        audioPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        audioPlayButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            audioPlayButton.leadingAnchor.constraint(equalTo: messageBackground.leadingAnchor, constant: 8),
            audioPlayButton.topAnchor.constraint(equalTo: messageBackground.topAnchor, constant: 8),
            audioPlayButton.heightAnchor.constraint(equalToConstant: 25),
            audioPlayButton.widthAnchor.constraint(equalToConstant: 25),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupAudioDurationLabel(){
        messageBackground.addSubview(durationLabel)
        durationLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            durationLabel.trailingAnchor.constraint(equalTo: messageBackground.trailingAnchor, constant: -8),
            durationLabel.centerYAnchor.constraint(equalTo: messageBackground.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
        
    @objc func playAudioButtonPressed(){
        chatVC.handleUserPressedAudioButton(for: self)
    }
    
    @objc func timerHandler(){
        if !audioPlayer.isPlaying {
            audioPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            timer.invalidate()
            chatVC.audioPlayer = nil
        }
        let (m,s) = timeFrom(seconds: Int(audioPlayer.duration - audioPlayer.currentTime))
        let minutes = m < 10 ? "0\(m)" : "\(m)"
        let seconds = s < 10 ? "0\(s)" : "\(s)"
        durationLabel.text = "\(minutes):\(seconds)"
    }
    
    func timeFrom(seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
}
