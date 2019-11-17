//
//  SelectProfileImageVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class SelectProfileImageVC: UIViewController {
    
    // User credentials
    var name: String!
    var email: String!
    var password: String!
    
    var profileImage = UIImageView(image: UIImage(named: "DefaultUserImage"))
    var selectImageButton = UIButton(type: .system)
    var continueButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProfileImage()
        setupButtons()
    }
 
    func setupButtons() {
        view.addSubview(selectImageButton)
        view.addSubview(continueButton)
        
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        selectImageButton.setTitle("Select Image", for: .normal)
        selectImageButton.setTitleColor(.white, for: .normal)
        selectImageButton.layer.cornerRadius = 16
        selectImageButton.backgroundColor = Constants.Colors.appColor
     
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.cornerRadius = 16
        continueButton.backgroundColor = Constants.Colors.appColor
       
        let constraints = [
            selectImageButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 50),
            selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectImageButton.widthAnchor.constraint(equalToConstant: 150),
            selectImageButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 20),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 150),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupProfileImage(){
        view.addSubview(profileImage)
        profileImage.contentMode = .scaleAspectFill
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 50
        let constraints = [
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
