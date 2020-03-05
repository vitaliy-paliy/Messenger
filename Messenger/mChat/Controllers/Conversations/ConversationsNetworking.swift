//
//  ConversationsNetworking.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/5/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ConversationsNetworking {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var convVC: ConversationsVC!
    var groupedMessages = [String: Messages]()
    var unreadMessages = [String: Int]()
    var friendKeys = [String]()
    var totalUnread = Int()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
   func observeFriendsList() {
        convVC.blankLoadingView.isHidden = false
        Database.database().reference().child("friendsList").child(CurrentUser.uid).observeSingleEvent(of: .value) { (snap) in
            for child in snap.children{
                guard let snapshot = child as? DataSnapshot else { return }
                guard let friend = snapshot.value as? [String:Any] else { return }
                self.friendKeys.append(contentsOf: Array(friend.keys))
            }
            guard self.friendKeys.count > 0 else {
                self.convVC.loadMessagesHandler(nil)
                return
            }
            self.messagesReference()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func observeFriendActions(){
        observeRemovedFriends()
        observeNewFriends()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func observeRemovedFriends(){
        Database.database().reference().child("friendsList").child(CurrentUser.uid).observe(.childRemoved) { (snap) in
            let friendToRemove = snap.key
            var index = 0
            for message in self.convVC.messages {
                if message.determineUser() == friendToRemove {
                    self.groupedMessages.removeValue(forKey: friendToRemove)
                    self.convVC.messages.remove(at: index)
                    self.removeFriendFromArray(friendToRemove)
                    self.convVC.tableView.reloadData()
                    return
                }
                index += 1
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func observeNewFriends(){
        Database.database().reference().child("friendsList").child(CurrentUser.uid).observe(.childAdded) { (snap) in
            let friendToAdd = snap.key
            let status = self.friendKeys.contains { (key) -> Bool in
                return key == friendToAdd
            }
            if status {
                return
            }else{
                self.friendKeys.append(friendToAdd)
                self.convVC.observeMessageActions()
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func removeFriendFromArray(_ friendToRemove: String){
        var index = 0
        for friend in friendKeys {
            if friendToRemove == friend {
                friendKeys.remove(at: index)
            }
            index += 1
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func messagesReference(){
        for key in friendKeys {
            Database.database().reference().child("messages").child(CurrentUser.uid).child(key).queryLimited(toLast: 1).observeSingleEvent(of: .value) { (snap) in
                guard snap.childrenCount > 0 else {
                    self.convVC.loadMessagesHandler(nil)
                    return
                }
                for child in snap.children {
                    guard let snapshot = child as? DataSnapshot else { return }
                    guard let values = snapshot.value as? [String : Any] else { return }
                    let message = ChatKit.setupUserMessage(for: values)
                    self.groupedMessages[message.determineUser()] = message
                }
                if key == self.friendKeys[self.friendKeys.count - 1] {
                    self.convVC.loadMessagesHandler(Array(self.groupedMessages.values))
                }
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func observeNewMessages(completion: @escaping (_ newMessages: [Messages]) -> Void){
        for key in friendKeys {
            Database.database().reference().child("messages").child(CurrentUser.uid).child(key).queryLimited(toLast: 1).observe(.childAdded) { (snap) in
                guard let values = snap.value as? [String: Any] else { return }
                let message = ChatKit.setupUserMessage(for: values)
                let status = self.convVC.messages.contains { (oldMessage) -> Bool in
                    return message.id == oldMessage.id
                }
                if status {
                    return
                }else{
                    self.groupedMessages[message.determineUser()] = message
                    return completion(Array(self.groupedMessages.values))
                }
            }
        }
        self.observeFriendActions()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func observeDeletedMessages() {
        for key in friendKeys {
            Database.database().reference().child("messages").child(CurrentUser.uid).child(key).queryLimited(toLast: 1).observe(.childRemoved) { (snap) in
                guard let values = snap.value as? [String: Any] else { return }
                let message = ChatKit.setupUserMessage(for: values)
                self.groupedMessages.removeValue(forKey: message.determineUser())
                self.convVC.messages = Array(self.groupedMessages.values)
                self.convVC.tableView.reloadData()
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func loadFriends(_ recent: Messages,completion: @escaping (_ friend: FriendInfo) -> Void){
        let user = recent.determineUser()
        let ref = Database.database().reference().child("users").child(user)
        ref.observe(.value) { (snap) in
            guard let values = snap.value as? [String: Any] else { return }
            var friend = FriendInfo()
            friend.id = snap.key
            friend.name = values["name"] as? String
            friend.email = values["email"] as? String
            friend.isOnline = values["isOnline"] as? Bool
            friend.lastLogin = values["lastLogin"] as? NSNumber
            friend.profileImage = values["profileImage"] as? String
            friend.isMapLocationEnabled = values["isMapLocationEnabled"] as? Bool
            return completion(friend)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func observeUserSeenMessage(_ friendId: String, completion: @escaping(_ userSeenMessagesCount: Int) -> Void){
        let ref = Database.database().reference().child("messages").child("unread-Messages").child(friendId).child(CurrentUser.uid)
        ref.observe(.value) { (snap) in
            return completion(Int(snap.childrenCount))
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func observeIsUserTyping(_ friendId: String, completion: @escaping (_ isTyping: Bool, _ friendId: String) -> Void){
        let ref = Database.database().reference().child("userActions").child(friendId).child(CurrentUser.uid)
        ref.observe(.value) { (snap) in
            guard let data = snap.value as? [String: Any] else { return }
            guard let isTyping = data["isTyping"] as? Bool else { return }
            guard let friendId = data["fromFriend"] as? String else { return }
            return completion(isTyping, friendId)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func removeConvObservers(){
        for message in convVC.messages {
            Database.database().reference().child("users").child(message.determineUser()).removeAllObservers()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func observeUnreadMessages(_ key: String, completion: @escaping(_ unreadMessages: [String: Int]) -> Void){
        Database.database().reference().child("messages").child("unread-Messages").child(CurrentUser.uid).child(key).observe(.value) { (snap) in
            self.totalUnread = 0
            self.unreadMessages[key] = Int(snap.childrenCount)
            self.addValueToBadge()
            return completion(self.unreadMessages)
        }
        Database.database().reference().child("messages").child("unread-Messages").child(CurrentUser.uid).child(key).observe(.childRemoved) { (snap) in
            self.removeValueFromBadge(key)
            self.unreadMessages.removeValue(forKey: key)
            return completion(self.unreadMessages)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func addValueToBadge() {
        for m in self.unreadMessages.values {
            totalUnread += m
        }
        if totalUnread != 0 {
            self.convVC.tabBarBadge.badgeValue = "\(totalUnread)"
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func removeValueFromBadge(_ key: String) {
        self.totalUnread -= self.unreadMessages[key] ?? 0
        if totalUnread == 0 {
            self.convVC.tabBarBadge.badgeValue = nil
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}


