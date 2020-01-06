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
        Database.database().reference().child("friendsList").child(CurrentUser.uid).observe(.childRemoved) { (snap) in
            print("Do Deletion")
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
    }
    
}

