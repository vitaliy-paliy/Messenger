//
//  LogoVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/30/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Lottie

class LogoVC: UIViewController {
        
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // LogoVC appears when user opens the app. It serves as a networking view.
    
    var animationView = AnimationView()
    var logoImage = UIImageView()
    var logoLabel = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = setupGradientLayer()
        gradient.frame = view.frame
        view.layer.insertSublayer(gradient, at: 0)
        setupLogo()
        setupLogoLabel()
        setupAnimationView()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLogo(){
        view.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.image = UIImage(named: "Logo-Light")
        logoImage.layer.cornerRadius = 75
        logoImage.layer.masksToBounds = true
        let constraints = [
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 150),
            logoImage.widthAnchor.constraint(equalToConstant: 150),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.midY/4)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLogoLabel() {
        view.addSubview(logoLabel)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.text = "mChat"
        logoLabel.font = UIFont.boldSystemFont(ofSize: 32)
        logoLabel.textColor = .white
        let constraints =  [
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupAnimationView() {
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.animation = Animation.named("settingUpAnimation")
        animationView.loopMode = .loop
        animationView.play()
        let constraints = [
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            animationView.heightAnchor.constraint(equalToConstant: 100),
            animationView.widthAnchor.constraint(equalToConstant: 100),
        ]
        NSLayoutConstraint.activate(constraints)
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

