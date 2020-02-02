//
//  UserListNetworking.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/1/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

class UserListNetworking {
        
    var userList = [String: FriendInfo]()
    var loadMore = false
    
    func fetchUsers(completion: @escaping (_ userList: [String:FriendInfo]) -> Void){
        // Add Pagination
        var ref: DatabaseQuery!
        var usersCount: UInt = 8
        let firstUser = Array(userList.values).first
        if firstUser == nil {
            ref = Database.database().reference().child("users").queryOrderedByKey().queryLimited(toLast: usersCount)
        }else{
            ref = Database.database().reference().child("users").child(firstUser!.id).queryOrderedByKey().queryLimited(toLast: usersCount)
        }
        ref.observeSingleEvent(of: .value) { (snap) in
            for child in snap.children {
                var user = FriendInfo()
                guard let snapshot = child as? DataSnapshot else { return }
                guard let values = snapshot.value as? [String: Any] else { return }
                user.email = values["email"] as? String
                user.profileImage = values["profileImage"] as? String
                user.name = values["name"] as? String
                user.id = snapshot.key
                if user.id != CurrentUser.uid {
                    self.userList[user.id] = user
                }
            }
            return completion(self.userList)
        }
    }
    
}

