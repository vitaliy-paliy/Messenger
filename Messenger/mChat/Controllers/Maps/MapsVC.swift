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

// Relocate protocol to a different swift file


protocol UserSelectedFriend {
    func zoomToSelectedFriend(friend: FriendInfo)
}

class MapsVC: UIViewController {
    
    var friends = [FriendInfo]()
    var isFriendSelected = false
    var selectedFriend = FriendInfo()
    var friendCoordinates = [String: CLLocationCoordinate2D]()
    var mapView = MGLMapView()
    var exitButton = UIButton(type: .system)
    var settingsButton = UIButton(type: .system)
    var userInfoTab: UserInfoTab?
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer(timeInterval: 20, target: self, selector: #selector(updateCurrentLocation), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        setupMapView()
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
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        if view.safeAreaInsets.top > 20 {
            setupExitButton(35)
            setupSettingsButton(35)
        }else{
            setupExitButton(20)
            setupSettingsButton(20)
        }
    }
    
    func setupMapView(){
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.automaticallyAdjustsContentInset = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: -8),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        mapView.styleURL = URL(string: "mapbox://styles/mapbox/streets-v11")
        mapView.delegate = self
        mapView.allowsRotating = false
        mapView.logoView.isHidden = true
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
            self.friendCoordinates[friend.id] = coordinate
            self.mapView.addAnnotation(friendPin)
            if self.isFriendSelected {
                guard let coordinate = self.friendCoordinates[self.selectedFriend.id] else { return }
                self.mapView.setCenter(coordinate, zoomLevel: 13, animated: true)
            }
        }
    }
    
    func setupSettingsButton(_ topConst: CGFloat){
        view.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.tintColor = .white
        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingsButton.tintColor = .white
        settingsButton.layer.shadowColor = UIColor.white.cgColor
        settingsButton.layer.shadowRadius = 10
        settingsButton.layer.shadowOpacity = 0.3
        settingsButton.addTarget(self, action: #selector(openMapsSettings), for: .touchUpInside)
        let constraints = [
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topConst),
            settingsButton.widthAnchor.constraint(equalToConstant: 45),
            settingsButton.heightAnchor.constraint(equalToConstant: 45),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupExitButton(_ topConst: CGFloat){
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        exitButton.tintColor = .white
        exitButton.layer.shadowColor = UIColor.white.cgColor
        exitButton.layer.shadowRadius = 10
        exitButton.layer.shadowOpacity = 0.3
        exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        let constraints = [
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topConst),
            exitButton.widthAnchor.constraint(equalToConstant: 45),
            exitButton.heightAnchor.constraint(equalToConstant: 45),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func exitButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openMapsSettings(){
        let controller = MapsSettingsVC()
        controller.isMapOpened = true
        presentingVC().present(UINavigationController(rootViewController: controller),animated: true, completion: nil)
    }
    
    func openUserMessagesHandler(_ friend: FriendInfo){
        let controller = ChatVC()
        controller.friend = friend
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    func presentingVC() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.windows[0].rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
        
}

extension MapsVC: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            return CurrentUserAnnotationView()
        }else{
            guard let pin = annotation as? AnnotationPin else { return nil }
            let reuseIdentifier = "FriendAnnotation"
            return FriendAnnotationView(annotation: pin, reuseIdentifier: reuseIdentifier, friend: pin.friend)
        }
        
    }
    
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        mapView.setCenter(annotation.coordinate, zoomLevel: 13, animated: true)
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.userInfoTab = UserInfoTab(annotation: annotation)
                self.view.addSubview(self.userInfoTab!)
            })
        }else{
            guard let pin = annotation as? AnnotationPin else { return }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.userInfoTab = UserInfoTab(annotation: pin)
                self.view.addSubview(self.userInfoTab!)
            })
        }
    }
    
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        self.userInfoTab?.removeFromSuperview()
        self.userInfoTab = nil
    }
    
}

extension MapsVC: UserSelectedFriend {
    
    func zoomToSelectedFriend(friend: FriendInfo) {
        selectedFriend = friend
        isFriendSelected = true
    }

}
