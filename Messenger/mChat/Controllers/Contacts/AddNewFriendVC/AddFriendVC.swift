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
    
    var user: FriendInfo!
    var addButton: UIButton!
    var addFriendNetworking = AddFriendNetworking()
    
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
    
    func setupNetworking() {
        addFriendNetworking.controller = self
        addFriendNetworking.friend = user
        addFriendNetworking.checkFriend()
    }
    
    func setupUI(){
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        setupGradientView()
        setupExitButton()
        setupUserInfoView()
    }
    
    func setupGradientView() {
        let _ = GradientLogoView(self, true)
    }
    
    func setupUserInfoView(){
        let infoView = UserInfoView(self)
        addButton = infoView.addButton
    }
    
    func setupExitButton() {
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
    
    @objc func exitButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func addButtonPressed() {
        if addButton.titleLabel?.text == "Add Friend" {
            addButton.setTitle("Requested", for: .normal)
            addButton.backgroundColor = .gray
        }else{
            addFriendNetworking.removeFriendRequest()
            addFriendNetworking.removeFriend()
            addButton.backgroundColor = .green
            addButton.setTitle("Add Friend", for: .normal)
            return
        }
        addFriendNetworking.addAsFriend()
    }
    
}

