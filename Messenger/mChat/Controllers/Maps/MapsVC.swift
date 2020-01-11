//
//  MapsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/8/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase
import Mapbox

class MapsVC: UIViewController {
    
    var friends = [FriendInfo]()
    var mapView = MGLMapView()
    var exitButton = UIButton(type: .system)
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer(timeInterval: 20, target: self, selector: #selector(updateCurrentLocation), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        setupMapView()
        setupExitButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeFriendsList()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupMapView(){
        mapView.frame = view.frame
        mapView.styleURL = URL(string: "mapbox://styles/mapbox/streets-v11")
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.allowsRotating = false
        mapView.showsUserLocation = true
    }
    
    @objc func updateCurrentLocation(){
        guard CurrentUser.isMapLocationEnabled else { return }
        guard let currentLocation = mapView.userLocation?.coordinate else { return }
        let ref = Database.database().reference().child("user-Location").child(CurrentUser.uid)
        let values = ["longitude": currentLocation.longitude, "latitude": currentLocation.latitude]
        ref.updateChildValues(values)
        print("Updated")
    }
    
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
            let status = self.mapView.annotations?.contains(where: { (annotation) -> Bool in
                guard let oldAnnotation = annotation as? AnnotationPin else { return false }
                annotationToDelete = oldAnnotation
                return oldAnnotation.friend.id == friendPin.friend.id
            })
            if status ?? false {
                self.mapView.removeAnnotation(annotationToDelete)
            }
            self.mapView.addAnnotation(friendPin)
            self.mapView.reloadInputViews()
        }
    }
    
    func setupExitButton(){
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        exitButton.tintColor = .white
        exitButton.layer.shadowRadius = 10
        exitButton.layer.shadowOpacity = 0.5
        exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        let constraints = [
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func exitButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
}

extension MapsVC: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            return CurrentUserAnnotationView()
        }else{
            guard let pin = annotation as? AnnotationPin else { return nil }
            return FriendAnnotationView(profileImage: pin.friend.profileImage)
        }
        
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        print("HI")
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        print("Hi")
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            print("fdfds")
            return nil
        }else{
            guard let pin = annotation as? AnnotationPin else { return nil }
            return UserCalloutView(annotation: pin)
        }
    }
    
}
