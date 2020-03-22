//
//  ChatKit.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/30/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase
import Mapbox

class ChatKit {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    static var mapTimer = Timer()
    static var map = MGLMapView()
        
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // UPDATES USER LOCATION
    
    static func startUpdatingUserLocation(){
        ChatKit.mapTimer = Timer(timeInterval: 20, target: self, selector: #selector(ChatKit.updateCurrentLocation), userInfo: nil, repeats: true)
        RunLoop.current.add(ChatKit.mapTimer, forMode: RunLoop.Mode.common)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // METHOD THAT CHECKS IF USER
    
    @objc static func updateCurrentLocation(){
        guard CurrentUser.isMapLocationEnabled ?? false else { return }
        guard let currentLocation = ChatKit.map.userLocation?.coordinate else { return }
        let ref = Database.database().reference().child("user-Location").child(CurrentUser.uid)
        let values = ["longitude": currentLocation.longitude, "latitude": currentLocation.latitude]
        ref.updateChildValues(values)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // SETS UP USER MESSAGE DATA.
    
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
        message.storageID = values["storageID"] as? String
        message.videoUrl = values["videoUrl"] as? String
        return message
    }
        
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
}
