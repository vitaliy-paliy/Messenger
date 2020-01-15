//
//  UserSelectedFriendProtocol + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/14/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

protocol UserSelectedFriend {
    func zoomToSelectedFriend(friend: FriendInfo)
}

extension MapsVC: UserSelectedFriend {
    
    func zoomToSelectedFriend(friend: FriendInfo) {
        selectedFriend = friend
        isFriendSelected = true
    }
    
}
