//
//  MapView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/15/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Mapbox

extension MapsVC: MGLMapViewDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            return CurrentUserAnnotationView()
        }else{
            guard let pin = annotation as? AnnotationPin else { return nil }
            let reuseIdentifier = "FriendAnnotation"
            return FriendAnnotationView(annotation: pin, reuseIdentifier: reuseIdentifier, friend: pin.friend)
        }
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        mapView.setCenter(annotation.coordinate, zoomLevel: 13, animated: true)
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.userInfoTab = UserInfoTab(annotation: annotation)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openMapsSettings))
                self.userInfoTab?.addGestureRecognizer(tapGesture)
                self.userInfoTab?.actionButton.addTarget(self, action: #selector(self.openMapsSettings), for: .touchUpInside)
                self.view.addSubview(self.userInfoTab!)
            })
        }else{
            guard let pin = annotation as? AnnotationPin else { return }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.userInfoTab = UserInfoTab(annotation: pin)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openUserMessagesHandler))
                self.selectedFriend = pin.friend
                self.userInfoTab?.addGestureRecognizer(tapGesture)
                self.userInfoTab?.actionButton.addTarget(self, action: #selector(self.openUserMessagesHandler), for: .touchUpInside)
                self.view.addSubview(self.userInfoTab!)
            })
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        self.userInfoTab?.removeFromSuperview()
        self.userInfoTab = nil
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
