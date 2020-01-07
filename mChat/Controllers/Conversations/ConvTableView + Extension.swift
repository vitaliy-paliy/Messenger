//
//  ConvTableView + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/7/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

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
        convNetworking.observeUnreadMessages(recent.determineUser()) { (unreadMessage) in
            if let numOfMessages = unreadMessage[recent.determineUser()], numOfMessages > 0 {
                cell.unreadMessageView.isHidden = false
                cell.unreadLabel.text = "\(numOfMessages)"
            }else{
                cell.unreadMessageView.isHidden = true
            }
        }
        observeIsUserTypingHandler(recent, cell)
        loadFriendsHandler(recent, cell)
        let date = NSDate(timeIntervalSince1970: recent.time.doubleValue)
        cell.timeLabel.text = calendar.calculateTimePassed(date: date)
        if recent.mediaUrl != nil {
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
        for usr in friends {
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
            }else{
                self.setupNoTypingCell(cell)
            }
        }
    }
    
    func loadFriendsHandler(_ recent: Messages, _ cell: ConversationsCell){
        convNetworking.loadFriends(recent) { (friend) in
            self.friends.append(friend)
            cell.friendName.text = friend.name
            cell.profileImage.loadImage(url: friend.profileImage)
            if friend.isOnline{
                cell.isOnlineView.isHidden = false
            }else{
                cell.isOnlineView.isHidden = true
            }
        }
    }
    
}
