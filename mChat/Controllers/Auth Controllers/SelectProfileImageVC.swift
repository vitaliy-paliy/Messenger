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
        setupButton(selectImageButton, "Select Image")
        setupButton(continueButton, "Continue")
        NSLayoutConstraint.activate(configureButtonsConstraints(selectImageButton, profileImage, 150, 40, 150))
        NSLayoutConstraint.activate(configureButtonsConstraints(continueButton, selectImageButton, 50, 40, 150))
    }
    
    func setupProfileImage(){
        view.addSubview(profileImage)
        setupImages(profileImage, .scaleAspectFill, 50, true)
        NSLayoutConstraint.activate(configureImagesConstraints(profileImage, 100, 100, view, 150))
    }
    
}
