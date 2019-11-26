//
//  Messages.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class Messages {
    var message: String!
    var sender: String!
    var recipient: String!
    var time: NSNumber!
    var mediaUrl: String!
    
    func determineUser() -> String{
        if sender == CurrentUser.uid {
            return recipient
        }else{
            return sender
        }
    }
    
}
