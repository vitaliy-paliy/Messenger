//
//  FriendInfo.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/18/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //
// FRIEND MODEL

struct FriendInfo {
    
    var id: String?
    
    var name: String?
    
    var profileImage: String?
    
    var email: String?
    
    var isOnline: Bool?
    
    var lastLogin: NSNumber?
    
    var isMapLocationEnabled: Bool?
    
    func userCheck() -> Bool{
        if id == nil || name == nil || profileImage == nil, email == nil{
            return false
        }
        return true
    }
    
    
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //
// USER'S FRIENDS LIST

class Friends {
    
    static var list = [FriendInfo]()
    
    static var convVC: ConversationsVC?
    
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //
// USER_IS_TYPING MODEL

struct FriendActivity{
    
    let isTyping: Bool?
    
    let friendId: String?
    
    init(isTyping: Bool, friendId: String) {
        
        self.isTyping = isTyping
        self.friendId = friendId
        
    }
    
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //
