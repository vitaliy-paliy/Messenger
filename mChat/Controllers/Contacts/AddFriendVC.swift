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
    var container = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupContainter()
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
    
    func setupContainter (){
        view.addSubview(container)
        container.backgroundColor = .white
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.cornerRadius = 20
        container.layer.shadowOpacity = 1
        container.layer.shadowOffset = .zero
        container.layer.shadowRadius = 10
        
        container.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            container.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
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
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            emailLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5),
            emailLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            emailLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureLabels(_ label: UILabel, _ text: String,  color: UIColor, size: CGFloat){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: size)
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = color
    }
    
    func configureLabelConstraints(){
        
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
        print("hi")
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}
