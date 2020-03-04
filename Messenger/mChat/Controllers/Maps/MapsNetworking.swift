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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var mapsVC: MapsVC!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func observeFriendLocation(){
        for friend in Friends.list {
            guard friend.isMapLocationEnabled else { return }
            Database.database().reference().child("user-Location").child(friend.id).observe(.value) { (snap) in
                guard let values = snap.value as? [String: Any] else { return }
                guard let latitude = values["latitude"] as? Double else { return }
                guard let longitude = values["longitude"] as? Double else { return }
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.handleFriendLocation(friend, coordinate)
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func handleFriendLocation(_ friend: FriendInfo, _ coordinate: CLLocationCoordinate2D) {
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
