//
//  ChatCollectionView + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/2/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import AVFoundation

extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = messages[indexPath.row]
        if let msg = message.message {
            height = calculateFrameInText(message: msg).height + 10
            if message.repMID != nil { height += 50 }
        }else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue  {
            height = CGFloat(imageHeight / imageWidth * 200)
        }else if message.audioUrl != nil {
            height = 40
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func calculateFrameInText(message: String) -> CGRect{
        return NSString(string: message).boundingRect(with: CGSize(width: 200, height: 9999999), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica Neue", size: 16)!], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        let message = messages[indexPath.row]
        cell.chatVC = self
        cell.message.text = message.message
        cell.msg = message
        if let message = message.message {
            cell.backgroundWidthAnchor.constant = calculateFrameInText(message: message).width + 32
        }
                
        if message.recipient == CurrentUser.uid{
            cell.isIncoming = true
            cell.outcomingMessage.isActive = false
            cell.incomingMessage.isActive = true
        }else{
            cell.isIncoming = false
            cell.incomingMessage.isActive = false
            cell.outcomingMessage.isActive = true
        }
        
        if message.mediaUrl != nil{
            cell.mediaMessage.loadImage(url: message.mediaUrl)
            cell.mediaMessage.isHidden = false
            cell.backgroundWidthAnchor.constant = 200
            cell.messageBackground.backgroundColor = .clear
        }else{
            cell.mediaMessage.isHidden = true
        }
        
        if message.audioUrl != nil {
            guard let url = URL(string: message.audioUrl!) else { return cell }
            cell.backgroundWidthAnchor.constant = 120
            cell.setupAudioPlayButton()
            chatNetworking.downloadMessageAudio(with: url) { (data, eror) in
                guard let data = data else { return }
                do{
                    cell.audioPlayer = try AVAudioPlayer(data: data)
                    cell.audioPlayButton.isEnabled = true
                    let (m,s) = cell.timeFrom(seconds: Int(cell.audioPlayer.duration - cell.audioPlayer.currentTime))
                    let minutes = m < 10 ? "0\(m)" : "\(m)"
                    let seconds = s < 10 ? "0\(s)" : "\(s)"
                    cell.setupAudioDurationLabel()
                    cell.durationLabel.text = "\(minutes):\(seconds)"
                }catch{
                    print(error.localizedDescription)
                }
            }
        }else{
            cell.durationLabel.removeFromSuperview()
            cell.audioPlayButton.removeFromSuperview()
        }
        
        if message.repMID != nil {
            cell.setupRepMessageView(message.repSender)
        }else{
            cell.removeReplyOutlets()
        }
        
        if message.sender == CurrentUser.uid && message.id == messages.last?.id {
            cell.activityLabel.isHidden = false
            cell.activityLabel.text = chatNetworking.messageStatus
        }else{
            cell.activityLabel.isHidden = true
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let sView = scrollView as? UICollectionView else { return }
        if sView.contentOffset.y + sView.adjustedContentInset.top == 0 {
            if !chatNetworking.loadMore && !chatNetworking.lastMessageReached {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                fetchMessages()
            }
        }
    }
    
}
