//
//  ContactsNetworking.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/16/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ContactsNetworking {
    
    var contactsVC: ContactsVC!
    var friendKeys = [String]()
    
    func observeFriendList(){
        Database.database().reference().child("friendsList").child(CurrentUser.uid).observeSingleEvent(of: .value) { (snap) in
            guard let friends = snap.value as? [String: Any] else {
                self.observeFriendActions()
                return
            }
            for dict in friends.keys {
                self.friendKeys.append(dict)
            }
            self.getFriendInfo()
        }
    }
    
    func observeFriendActions(){
        observeNewFriend()
        observeRemovedFriends()
    }
        
    func observeNewFriend(){
        Database.database().reference().child("friendsList").child(CurrentUser.uid).observe(.childAdded) { (snap) in
            let friend = snap.key
            let status = self.friendKeys.contains { (key) -> Bool in
                return friend == key
            }
            if status {
                return
            }else{
                self.friendKeys.append(friend)
                self.updateFriendInfo(friend)
            }
        }
    }
    
    func observeRemovedFriends(){
        Database.database().reference().child("friendsList").child(CurrentUser.uid).observe(.childRemoved) { (snap) in
            let friendToRemove = snap.key
            var index = 0
            for friend in self.contactsVC.friendsList {
                if friend.id == friendToRemove {
                    self.contactsVC.friendsList.remove(at: index)
                    self.removeFriendFromArray(friendToRemove)
                    self.contactsVC.tableView.reloadData()
                    return
                }
                index += 1
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
    
    func getFriendInfo(){
        for key in friendKeys {
            Database.database().reference().child("users").child(key).observe(.value) { (snap) in
                guard let values = snap.value as? [String: Any] else { return }
                self.setupFriendInfo(for: key, values)
                if key == self.friendKeys[self.friendKeys.count - 1] {
                    print("Reload")
                    self.contactsVC.handleReload()
                    self.observeFriendActions()
                }
            }
        }
    }
    
    func updateFriendInfo(_ key: String){
        Database.database().reference().child("users").child(key).observe(.value) { (snap) in
            guard let values = snap.value as? [String: Any] else { return }
            self.setupFriendInfo(for: key, values)
            self.contactsVC.handleReload()
        }
    }
    
    func setupFriendInfo(for key: String, _ values: [String: Any]){
        var friend = FriendInfo()
        friend.id = key
        friend.email = values["email"] as? String
        friend.profileImage = values["profileImage"] as? String
        friend.name = values["name"] as? String
        friend.isOnline = values["isOnline"] as? Bool
        friend.lastLogin = values["lastLogin"] as? NSNumber
        friend.isMapLocationEnabled = values["isMapLocationEnabled"] as? Bool
        self.contactsVC.friendsList.append(friend)
        self.contactsVC.friendsList.sort { (friend1, friend2) -> Bool in
            return friend1.name < friend2.name
        }
    }
    
}
