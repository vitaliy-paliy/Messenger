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
    
    var nameLabel = UILabel()
    var emailLabel = UILabel()
    var backButton = UIButton(type: .system)
    var image = UIImageView()
    var addFriendButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupImage()
        setupLabels()
        setupButtons()
        
        print(email!, name!)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
        
    func setupImage(){
        image.loadImage(url: profileImage)
        view.addSubview(image)
        setupImages(image, .scaleAspectFill, 50, true)
        NSLayoutConstraint.activate(configureImagesConstraints(image, 100, 100, view, 60))
    }
    
    func setupLabels(){
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = name
        nameLabel.textAlignment = .center
        
        nameLabel.font = UIFont(name: "Helvetica Neue", size: 25)
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 50),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupButtons(){
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.layer.cornerRadius = 20
        backButton.backgroundColor = Constants.Colors.appColor
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.tintColor = .white
        let constraints = [
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
        
}
