//
//  FriendInfo.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/18/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

struct FriendInfo {
    var id: String!
    var name: String!
    var profileImage: String!
    var email: String!
    var isOnline: Bool!
    var lastLogin: NSNumber!
    var isMapLocationEnabled: Bool!
}

struct FriendActivity{
    var isTyping: Bool!
    var friendId: String!
    init(isTyping: Bool, friendId: String) {
        self.isTyping = isTyping
        self.friendId = friendId
    }
}
