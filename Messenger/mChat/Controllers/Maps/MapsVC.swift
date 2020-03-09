//
//  MapsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/8/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Mapbox

class MapsVC: UIViewController, UIGestureRecognizerDelegate{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MapsVC is responsible for showing location of users' friends. (If their incognito mode is set to off.)
    
    let mapNetworking = MapsNetworking()
    var isFriendSelected = false
    var selectedFriend = FriendInfo()
    var friendCoordinates = [String: CLLocationCoordinate2D]()
    
    var userInfoTab: UserInfoTab?
    let mapView = MGLMapView()
    var exitButton: MapExitButton!
    var settingsButton: MapSettingsButton!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkStatus()
        userMapHandler()
        setupControllButtons()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapNetworking.mapsVC = self
        mapNetworking.observeFriendLocation()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func checkStatus(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            setupMapView()
        case .denied:
            deniedAlertController()
        default:
            break
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func updateMapStyle() {
        mapView.styleURL = URL(string: ThemeColors.selectedMapUrl)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupControllButtons() {
        exitButton = MapExitButton(mapsVC: self)
        settingsButton = MapSettingsButton(mapsVC: self)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupMapView(){
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
        mapView.styleURL = URL(string: ThemeColors.selectedMapUrl)
        mapView.delegate = self
        mapView.allowsRotating = false
        mapView.logoView.isHidden = true
        mapView.showsUserLocation = true
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func userMapHandler(){
        if !ChatKit.mapTimer.isValid {
            ChatKit.map.showsUserLocation = true
            ChatKit.startUpdatingUserLocation()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func exitButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func openMapsSettings(){
        let controller = MapsSettingsVC()
        controller.isMapOpened = true
        controller.mapsVC = self    
        present(UINavigationController(rootViewController: controller),animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func openUserMessagesHandler(){
        let controller = ChatVC()
        controller.friend = selectedFriend
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func presentingVC() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.windows[0].rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func deniedAlertController(){
        let alertController = UIAlertController(title: "Error", message: "To be able to see the map you need to change your location settings. To do this, go to Settings/Privacy/Location Services/mChat/ and allow location access. ", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
