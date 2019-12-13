//
//  FriendInfo.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/18/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

class UserInfo{
    var id: String!
    var email: String!
    var name: String!
    var profileImage: String!
}

class FriendInfo {
    var id: String!
    var name: String!
    var profileImage: String!
    var email: String!
    var isOnline: Bool!
    var lastLogin: NSNumber!
}

class FriendActivity{
    var isTyping: Bool!
    var friendId: String!
}
