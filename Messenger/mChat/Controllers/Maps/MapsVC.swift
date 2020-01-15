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

class MapsVC: UIViewController, UIGestureRecognizerDelegate {
    
    var mapNetworking = MapsNetworking()
    var friends = [FriendInfo]()
    var isFriendSelected = false
    var selectedFriend = FriendInfo()
    var friendCoordinates = [String: CLLocationCoordinate2D]()
    
    var mapView = MGLMapView()
    var exitButton = UIButton(type: .system)
    var settingsButton = UIButton(type: .system)
    var userInfoTab: UserInfoTab?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkStatus()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if !MessageKit.timer.isValid {
            print("Is Valid")
            startUpdatingUserLocation()
        }
    }
    
    func checkStatus(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            setupMapView()
        case .denied:
            deniedAlertController()
        default:
            break
        }
    }
    
    func startUpdatingUserLocation(){
        MessageKit.timer = Timer(timeInterval: 20, target: self, selector: #selector(mapNetworking.updateCurrentLocation), userInfo: nil, repeats: true)
        RunLoop.current.add(MessageKit.timer, forMode: RunLoop.Mode.common)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapNetworking.mapsVC = self
        mapNetworking.observeFriendsList()
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
        navigationController?.popViewController(animated: true)
    }
    
    @objc func openMapsSettings(){
        let controller = MapsSettingsVC()
        controller.isMapOpened = true
        present(UINavigationController(rootViewController: controller),animated: true, completion: nil)
    }
    
    @objc func openUserMessagesHandler(){
        let controller = ChatVC()
        controller.friend = selectedFriend
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func presentingVC() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.windows[0].rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
 
    func deniedAlertController(){
        let alertController = UIAlertController(title: "Error", message: "To be able to see the map you need to change your location settings. To do this, go to Settings/Privacy/Location Services/mChat/ and allow location access. ", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alertController, animated: true, completion: nil)
    }
            
}
