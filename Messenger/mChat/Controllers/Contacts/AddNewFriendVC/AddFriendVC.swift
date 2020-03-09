//
//  AddFriendVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/18/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class AddFriendVC: UIViewController{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var user: FriendInfo!
    var addButton: UIButton!
    let addFriendNetworking = AddFriendNetworking()
    var loadingIndicator: UIActivityIndicatorView!
    var greenGradientLayer: CALayer!
    var redGradientLayer: CALayer!
    var grayGradientLayer: CALayer!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNetworking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNetworking() {
        addFriendNetworking.controller = self
        addFriendNetworking.friend = user
        addFriendNetworking.checkFriend()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUI(){
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        handleButtonGradient()
        setupGradientView()
        setupExitButton()
        setupUserInfoView()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func handleButtonGradient() {
        for g in ["red","green","gray"] {
            let gradient = setupButtonGradientLayer(g)
            if g == "red"{
                redGradientLayer = gradient
            }else if g == "green"{
                greenGradientLayer = gradient
            }else{
                grayGradientLayer = gradient
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupButtonGradientLayer(_ color: String) -> CALayer {
        let gradient = CAGradientLayer()
        var firstColor: CGColor!
        var secondColor: CGColor!
        if color == "green" {
            firstColor = UIColor(red: 100/255, green: 200/255, blue: 110/255, alpha: 1).cgColor
            secondColor = UIColor(red: 150/255, green: 210/255, blue: 130/255, alpha: 1).cgColor
        }else if color == "red"{
            firstColor = UIColor(red: 235/255, green: 155/255, blue: 125/255, alpha: 1).cgColor
            secondColor = UIColor(red: 230/255, green: 80/255, blue: 70/255, alpha: 1).cgColor
        }else{
            firstColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
            secondColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        }
        gradient.colors = [firstColor!, secondColor!]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.locations = [0, 1]
        gradient.frame = CGRect(x: 0, y: 0, width: 200, height: 35)
        return gradient
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupGradientView() {
        let _ = GradientLogoView(self, true)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUserInfoView(){
        let infoView = UserInfoView(self)
        addButton = infoView.addButton
        loadingIndicator = infoView.loadingIndicator
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupExitButton() {
        let exitButton = UIButton(type: .system)
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setBackgroundImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        exitButton.tintColor = .white
        exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        let constraints = [
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            exitButton.widthAnchor.constraint(equalToConstant: 32),
            exitButton.heightAnchor.constraint(equalToConstant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //s
    
    @objc private func exitButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func addButtonPressed() {
        if addButton.titleLabel?.text == "Add Friend" {
            addButton.setTitle("Requested", for: .normal)
            addButton.layer.insertSublayer(grayGradientLayer, at: 0)
            redGradientLayer.removeFromSuperlayer()
            greenGradientLayer.removeFromSuperlayer()
        }else{
            addFriendNetworking.removeFriendRequest()
            addFriendNetworking.removeFriend()
            addButton.layer.insertSublayer(greenGradientLayer, at: 0)
            redGradientLayer.removeFromSuperlayer()
            grayGradientLayer.removeFromSuperlayer()
            addButton.setTitle("Add Friend", for: .normal)
            return
        }
        addFriendNetworking.addAsFriend()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

