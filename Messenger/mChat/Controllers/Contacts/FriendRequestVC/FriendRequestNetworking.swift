//
//  FriendRequestNetworking.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/6/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

class FriendRequestNetworking {
    
    var controller: FriendRequestVC!
    var friendKeys = [String]()
    var groupedUsers = [String:FriendInfo]()
    
    func loadRequests(completion: @escaping() -> Void) {
        Database.database().reference().child("friendsList").child("friendRequests").child(CurrentUser.uid).observeSingleEvent(of: .value) { (snap) in
            guard let values = snap.value as? [String:Any] else { return }
            self.friendKeys.append(contentsOf: Array(values.keys))
            return completion()
        }
    }
    
    func setupFriendRequests() {
        loadRequests {
            self.fetchUsers()
        }
    }
    
    func fetchUsers() {
        for key in friendKeys {
            Database.database().reference().child("users").child(key).observeSingleEvent(of: .value) { (snap) in
                guard let values = snap.value as? [String: Any] else { return }
                self.setupFriendInfo(for: key, values)
                self.controller.friendRequests = Array(self.groupedUsers.values)
                self.controller.friendRequests.sort { (friend1, friend2) -> Bool in
                    return friend1.name < friend2.name
                }
                self.controller.tableView.reloadData()
            }
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
        groupedUsers[key] = friend
    }
    
    func addAsFriend(_ friend: FriendInfo, completion: @escaping () -> Void) {
        let userRef = Database.database().reference().child("friendsList").child(CurrentUser.uid).child(friend.id).child(friend.id)
        let friendRef = Database.database().reference().child("friendsList").child(friend.id).child(CurrentUser.uid).child(CurrentUser.uid)
        userRef.setValue(true)
        friendRef.setValue(true)
        self.removeRequestFromDB(friend) {
            return completion()
        }
    }
    
    func declineUser(_ userToDelete: FriendInfo, completion: @escaping() -> Void) {
        self.removeRequestFromDB(userToDelete) {
            return completion()
        }
    }
    
    func removeRequestFromDB(_ user: FriendInfo, completion: @escaping () -> Void) {
        self.groupedUsers.removeValue(forKey: user.id)
        Database.database().reference().child("friendsList").child("friendRequests").child(CurrentUser.uid).child(user.id).child(user.id).removeValue { (error, ref) in
            return completion()
        }
    }
    
}
