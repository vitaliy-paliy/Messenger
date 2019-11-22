//
//  AddFriendVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/18/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class AddFriendVC: UIViewController, UINavigationBarDelegate{
    
    var friendId: String!
    var profileImage: String!
    var name: String!
    var email: String!
    var isFriend = false
    
    var nameLabel = UILabel()
    var emailLabel = UILabel()
    var backButton = UIButton(type: .system)
    var image = UIImageView()
    var addFriendButton = UIButton(type: .system)
    var container = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFriend()
        view.backgroundColor = .white
    }
    
    func setupUI(){
        setupContainter()
        setupImage()
        setupLabels()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupContainter(){
        view.addSubview(container)
        container.backgroundColor = .white
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.cornerRadius = 20
        container.layer.shadowOpacity = 1
        container.layer.shadowOffset = .zero
        container.layer.shadowRadius = 10
        
        container.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            container.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.heightAnchor.constraint(equalToConstant: 400),
            container.widthAnchor.constraint(equalToConstant: 300)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupImage(){
        image.loadImage(url: profileImage)
        view.addSubview(image)
        setupImages(image, .scaleAspectFill, 50, true)
        NSLayoutConstraint.activate(configureImagesConstraints(image, 100, 100, container, 20))
    }
    
    func setupLabels(){
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        configureLabels(nameLabel, name, color: .black, size: 25)
        configureLabels(emailLabel, email, color: .systemGray, size: 18)
        NSLayoutConstraint.activate(configureLabelConstraints(view: container, label: nameLabel, topEqualTo: image, topConst: 20))
        NSLayoutConstraint.activate(configureLabelConstraints(view: container, label: emailLabel, topEqualTo: nameLabel, topConst: 0))
    }
    
    func setupButtons(){
        view.addSubview(backButton)
        view.addSubview(addFriendButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.layer.cornerRadius = 20
        backButton.backgroundColor = Constants.Colors.appColor
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.tintColor = .white
        
        setupButton(addFriendButton, "Add Friend")
        NSLayoutConstraint.activate(configureButtonsConstraints(addFriendButton, emailLabel, 50, 40, 150))
        addFriendButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        let constraints = [
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func addButtonPressed(){
        let user = Constants.db.reference().child("friendsList").child(CurrentUser.uid).child(friendId)
        let friend = Constants.db.reference().child("friendsList").child(friendId).child(CurrentUser.uid)
        if !isFriend {
            updateFriendship(user: user, friend: friend, status: !isFriend)
            self.showAlert(title: "Success", message: "User was successfully added to your friends list")
        }else{
            updateFriendship(user: user, friend: friend, status: !isFriend)
        }
    }
    
    func updateFriendship(user: DatabaseReference, friend: DatabaseReference, status: Bool){
        user.setValue(status)
        friend.setValue(status)
        isFriend = status
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func checkFriend(){
        Constants.db.reference().child("friendsList").child(CurrentUser.uid).observe(.value) { (snapshot) in
            guard let values = snapshot.value as? [String: Any] else { return }
            let f = values
            if f[self.friendId] as? Bool != nil && f[self.friendId] as? Bool == true {
                self.isFriend = true
            }
        }
        setupUI()
    }
    
}

