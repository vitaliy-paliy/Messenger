//
//  MapsNetworking.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/14/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase
import Mapbox

class MapsNetworking {
    
    var mapsVC: MapsVC!
    
    func observeFriendsList(){
        Database.database().reference().child("friendsList").child(CurrentUser.uid).observeSingleEvent(of: .value) { (snap) in
            var friendIds = [String]()
            for child in snap.children {
                guard let snapshot = child as? DataSnapshot else { return }
                guard let values = snapshot.value as? [String : Any] else { return }
                friendIds.append(contentsOf: Array(values.keys))
            }
            for friendId in friendIds {
                self.observeFriends(friendId)
            }
        }
    }
    
    func observeFriends(_ id: String){
        Database.database().reference().child("users").child(id).observe(.value) { (snap) in
            guard let values = snap.value as? [String : Any] else { return }
            var friend = FriendInfo()
            friend.id = id
            friend.email = values["email"] as? String
            friend.profileImage = values["profileImage"] as? String
            friend.name = values["name"] as? String
            friend.isOnline = values["isOnline"] as? Bool
            friend.lastLogin = values["lastLogin"] as? NSNumber
            friend.isMapLocationEnabled = values["isMapLocationEnabled"] as? Bool
            self.mapsVC.friends.append(friend)
            self.observeFriendLocation(friend)
        }
    }
    
    func observeFriendLocation(_ friend: FriendInfo){
        guard friend.isMapLocationEnabled else { return }
        Database.database().reference().child("user-Location").child(friend.id).observe(.value) { (snap) in
            guard let values = snap.value as? [String: Any] else { return }
            guard let latitude = values["latitude"] as? Double else { return }
            guard let longitude = values["longitude"] as? Double else { return }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let friendPin = AnnotationPin(coordinate, friend)
            var annotationToDelete: AnnotationPin!
            let status = self.mapsVC.mapView.annotations?.contains(where: { (annotation) -> Bool in
                guard let oldAnnotation = annotation as? AnnotationPin else { return false }
                annotationToDelete = oldAnnotation
                return oldAnnotation.friend.id == friendPin.friend.id
            })
            if status ?? false {
                self.mapsVC.mapView.removeAnnotation(annotationToDelete)
            }
            self.mapsVC.friendCoordinates[friend.id] = coordinate
            self.mapsVC.mapView.addAnnotation(friendPin)
            if self.mapsVC.isFriendSelected {
                guard let coordinate = self.mapsVC.friendCoordinates[self.mapsVC.selectedFriend.id] else { return }
                self.mapsVC.mapView.setCenter(coordinate, zoomLevel: 13, animated: true)
            }
        }
    }
    
}
