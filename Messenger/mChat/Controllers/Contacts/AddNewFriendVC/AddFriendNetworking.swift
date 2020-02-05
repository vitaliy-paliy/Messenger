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
    
    func addAsFriend(){
        let user = Database.database().reference().child("friendsList").child(CurrentUser.uid).child(friend.id).child(self.friend.id)
        let friend = Database.database().reference().child("friendsList").child(self.friend.id).child(CurrentUser.uid).child(CurrentUser.uid)
        if !isFriend {
            updateFriendship(user: user, friend: friend, status: !isFriend)
        }else{
            user.removeValue()
            friend.removeValue()
            isFriend = false
        }
    }
    
    func updateFriendship(user: DatabaseReference, friend: DatabaseReference, status: Bool){
        user.setValue(status)
        friend.setValue(status)
        isFriend = status
    }
    
    
    func checkFriend(){
        Database.database().reference().child("friendsList").child(CurrentUser.uid).child(friend.id).observe(.value) { (snapshot) in
            guard let values = snapshot.value as? [String: Any] else { return }
            let f = values
            if f[self.friend.id] as? Bool != nil && f[self.friend.id] as? Bool == true {
                self.isFriend = true
            }
        }
    }
    
}
