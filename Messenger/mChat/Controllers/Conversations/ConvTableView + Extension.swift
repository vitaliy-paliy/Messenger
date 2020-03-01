//
//  ConvTableView + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/7/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

extension ConversationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func setupNoTypingCell(_ cell: ConversationsCell){
        cell.isTypingView.isHidden = true
        cell.recentMessage.isHidden = false
        cell.timeLabel.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationsCell") as! ConversationsCell
        cell.selectionStyle = .none
        let recent = messages[indexPath.row]
        cell.message = recent
        setupNoTypingCell(cell)
        cell.unreadMessageView.isHidden = true
        convNetworking.observeUnreadMessages(recent.determineUser()) { (unreadMessage) in
            if let numOfMessages = unreadMessage[cell.message.determineUser()], numOfMessages > 0 {
                cell.unreadMessageView.isHidden = false
                cell.unreadLabel.text = "\(numOfMessages)"
            }else{
                cell.unreadMessageView.isHidden = true
            }
        }
        for friend in Friends.list {
            if recent.determineUser() == friend.id {
                cell.friendName.text = friend.name
                cell.profileImage.loadImage(url: friend.profileImage)
                if friend.isOnline{
                    cell.isOnlineView.isHidden = false
                }else{
                    cell.isOnlineView.isHidden = true
                }
            }
        }
        observeIsUserTypingHandler(recent, cell)
        cell.checkmark.image = UIImage(named: "checkmark_icon")
        if recent.sender == CurrentUser.uid {
            Database.database().reference().child("messages").child("unread-Messages").child(recent.determineUser()).child(CurrentUser.uid).removeAllObservers()
            observeIsUserSeenMessage(recent, cell)
            cell.checkmark.isHidden = false
        }else{
            cell.checkmark.isHidden = true
        }
        let date = NSDate(timeIntervalSince1970: recent.time.doubleValue)
        cell.timeLabel.text = calendar.calculateTimePassed(date: date)
        if recent.mediaUrl != nil || recent.videoUrl != nil {
            cell.recentMessage.text = "[Media Message]"
        }else if recent.audioUrl != nil {
            cell.recentMessage.text = "[Audio Message]"
        }else{
            cell.recentMessage.text = recent.message
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chat = messages[indexPath.row]
        for usr in Friends.list {
            if usr.id == chat.determineUser() {
                nextControllerHandler(usr: usr)
                break
            }
        }
    }
        
    func observeIsUserTypingHandler(_ recent: Messages, _ cell: ConversationsCell){
        convNetworking.observeIsUserTyping(recent.determineUser()) { (isTyping, friendId) in
            if isTyping && cell.message.determineUser() == friendId {
                cell.recentMessage.isHidden = true
                cell.timeLabel.isHidden = true
                cell.isTypingView.isHidden = false
                cell.checkmark.isHidden = true
            }else{
                self.setupNoTypingCell(cell)
                if cell.message.sender == CurrentUser.uid{
                    cell.checkmark.isHidden = false
                }
            }
        }
    }
    
    func observeIsUserSeenMessage(_ recent: Messages, _ cell: ConversationsCell) {
        convNetworking.observeUserSeenMessage(cell.message.determineUser()) { (num) in
            if num == 0 {
                cell.checkmark.image = UIImage(named: "doubleCheckmark_icon")
            }else{
                cell.checkmark.image = UIImage(named: "checkmark_icon")
            }
        }
    }
    
}
