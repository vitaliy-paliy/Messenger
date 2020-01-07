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
    
    var convVC: ConversationsVC!
    var groupedMessages = [String: Messages]()
    var unreadMessages = [String: Int]()
    var friendKeys = [String]()
    
    func observeFriendsList() {
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
    
    func observeFriendActions(){
        observeRemovedFriends()
        observeNewFriends()
    }
    
    func observeRemovedFriends(){
        Database.database().reference().child("friendsList").child(CurrentUser.uid).observe(.childRemoved) { (snap) in
            print("Removed handler fired: ConvVC")
            guard let values = snap.value as? [String: Any] else { return }
            var friendToRemove: String!
            var index = 0
            for key in values.keys {
                friendToRemove = key
            }
            for message in self.convVC.messages {
                if message.determineUser() == friendToRemove {
                    self.groupedMessages.removeValue(forKey: friendToRemove)
                    self.convVC.messages.remove(at: index)
                    self.convVC.tableView.reloadData()
                }
                index += 1
            }
            self.removeFriendFromArray(friendToRemove)
        }
    }
    
    func observeNewFriends(){
        Database.database().reference().child("friendsList").child(CurrentUser.uid).observe(.childAdded) { (snap) in
            print("Add handler fired: ConvVC")
            guard let values = snap.value as? [String: Any] else { return }
            var friendToAdd: String!
            for key in values.keys {
                friendToAdd = key
            }
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
    
    func removeFriendFromArray(_ friendToRemove: String){
        var index = 0
        for friend in friendKeys {
            if friendToRemove == friend {
                friendKeys.remove(at: index)
            }
            index += 1
        }
    }
    
    func messagesReference(){
        for key in friendKeys {
            Database.database().reference().child("messages").child(CurrentUser.uid).child(key).queryLimited(toLast: 1).observeSingleEvent(of: .value) { (snap) in
                guard snap.childrenCount > 0 else {
                    self.convVC.loadMessagesHandler(nil)
                    return
                }
                for child in snap.children {
                    guard let snapshot = child as? DataSnapshot else { return }
                    guard let values = snapshot.value as? [String : Any] else { return }
                    let message = MessageKit.setupUserMessage(for: values)
                    self.groupedMessages[message.determineUser()] = message
                }
                if key == self.friendKeys[self.friendKeys.count - 1] {
                    self.convVC.loadMessagesHandler(Array(self.groupedMessages.values))
                }
            }
        }
    }
    
    func observeNewMessages(completion: @escaping (_ newMessages: [Messages]) -> Void){
        for key in friendKeys {
            Database.database().reference().child("messages").child(CurrentUser.uid).child(key).queryLimited(toLast: 1).observe(.childAdded) { (snap) in
                guard let values = snap.value as? [String: Any] else { return }
                let message = MessageKit.setupUserMessage(for: values)
                self.groupedMessages[message.determineUser()] = message
                return completion(Array(self.groupedMessages.values))
            }
        }
        self.observeFriendActions()
    }
    
    func loadFriends(_ recent: Messages,completion: @escaping (_ friend: FriendInfo) -> Void){
        let user = recent.determineUser()
        let ref = Database.database().reference().child("users").child(user)
        ref.observe(.value) { (snap) in
            guard let data = snap.value as? [String: Any] else { return }
            var friend = FriendInfo()
            friend.id = snap.key
            friend.name = data["name"] as? String
            friend.email = data["email"] as? String
            friend.isOnline = data["isOnline"] as? Bool
            friend.lastLogin = data["lastLogin"] as? NSNumber
            friend.profileImage = data["profileImage"] as? String
            return completion(friend)
        }
    }
    
    func observeIsUserTyping(_ friendId: String, completion: @escaping (_ isTyping: Bool, _ friendId: String) -> Void){
        let ref = Database.database().reference().child("userActions").child(friendId).child(CurrentUser.uid)
        ref.observe(.value) { (snap) in
            guard let data = snap.value as? [String: Any] else { return }
            guard let isTyping = data["isTyping"] as? Bool else { return }
            guard let friendId = data["fromFriend"] as? String else { return }
            return completion(isTyping, friendId)
        }
    }
    
    func removeConvObservers(){
        for message in convVC.messages {
            Database.database().reference().child("userActions").child(message.determineUser()).child(CurrentUser.uid).removeAllObservers()
            Database.database().reference().child("users").child(message.determineUser()).removeAllObservers()
        }
    }
    
    func observeUnreadMessages(_ key: String, completion: @escaping(_ unreadMessages: [String: Int]) -> Void){
        Database.database().reference().child("unread-Messages").child(CurrentUser.uid).child(key).observe(.value) { (snap) in
            self.unreadMessages[key] = Int(snap.childrenCount)
            return completion(self.unreadMessages)
        }
        Database.database().reference().child("unread-Messages").child(CurrentUser.uid).child(key).observe(.childRemoved) { (snap) in
            self.unreadMessages.removeValue(forKey: key)
            return completion(self.unreadMessages)
        }
    }
    
}


