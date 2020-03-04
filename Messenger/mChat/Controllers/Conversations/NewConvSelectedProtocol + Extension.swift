//
//  NewConvSelectedProtocol + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/7/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //

protocol NewConversationSelected {
    func showSelectedUser(selectedFriend: FriendInfo)
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //

extension ConversationsVC: NewConversationSelected {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func showSelectedUser(selectedFriend: FriendInfo) {
        nextControllerHandler(usr: selectedFriend)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
