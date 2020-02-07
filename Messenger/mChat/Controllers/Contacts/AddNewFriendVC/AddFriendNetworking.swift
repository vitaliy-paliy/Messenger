//
//  AddFriendNetworking.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/4/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

class AddFriendNetworking {
    
    var isFriend = false
    var friend: FriendInfo!
    var controller: AddFriendVC!
    
    func checkFriendship(){
        if !isFriend {
            addAsFriend()
        }else{
            removeFriend()
        }
    }
    
    func addAsFriend() {
        let ref = Database.database().reference().child("friendsList").child("friendRequests").child(friend.id).child(CurrentUser.uid)
        ref.setValue(CurrentUser.uid)
    }
    
    func removeFriend() {
        let userRef = Database.database().reference().child("friendsList").child(CurrentUser.uid).child(friend.id).child(self.friend.id)
        let friendRef = Database.database().reference().child("friendsList").child(self.friend.id).child(CurrentUser.uid).child(CurrentUser.uid)
        userRef.removeValue()
        friendRef.removeValue()
        isFriend = false
    }
    
    
    func checkFriend(){
        Database.database().reference().child("friendsList").child(CurrentUser.uid).child(friend.id).observe(.value) { (snapshot) in
            self.controller.addButton.isEnabled = true
            guard let values = snapshot.value as? [String: Any] else {
                self.controller.addButton.setTitle("Add Friend", for: .normal)
                self.controller.addButton.backgroundColor = .green
                return
            }
            let f = values
            if f[self.friend.id] as? Bool != nil && f[self.friend.id] as? Bool == true {
                self.controller.addButton.backgroundColor = .red
                self.controller.addButton.setTitle("Remove Friend", for: .normal)
                self.isFriend = true
            }
        }
    }
    
}
