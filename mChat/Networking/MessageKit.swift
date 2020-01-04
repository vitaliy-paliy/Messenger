//
//  MessageKit.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/30/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class MessageKit {
    
    static func setupUserMessage(for values: [String:Any]) -> Messages{
        let message = Messages()
        message.sender = values["sender"] as? String
        message.recipient = values["recipient"] as? String
        message.message = values["message"] as? String
        message.time = values["time"] as? NSNumber
        message.mediaUrl = values["mediaUrl"] as? String
        message.audioUrl = values["audioUrl"] as? String
        message.imageWidth = values["width"] as? NSNumber
        message.imageHeight = values["height"] as? NSNumber
        message.id = values["messageId"] as? String
        message.repMessage = values["repMessage"] as? String
        message.repMediaMessage = values["repMediaMessage"] as? String
        message.repMID = values["repMID"] as? String
        message.repSender = values["repSender"] as? String
        return message
    }
    
}
