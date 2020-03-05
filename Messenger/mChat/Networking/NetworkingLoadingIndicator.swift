//
//  NetworkingLoadingIndicator.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/29/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Lottie

class NetworkingLoadingIndicator {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // SETS UP A LOADING VIEW WHILE NETWORKING PROCESS
    
    let window = UIApplication.shared.windows[0]
    var blurView = UIVisualEffectView()
    var animationView = AnimationView()
    var loadingView = UIView()
    var loadingLabel = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func endLoadingAnimation(){
        animationView.removeFromSuperview()
        blurView.removeFromSuperview()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func startLoadingAnimation() {
        window.addSubview(blurView)
        blurView.frame = window.frame
        blurView.effect = UIBlurEffect(style: .dark)
        setupLoadingView()
        setupAnimationView()
        setupLoadingLabel()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLoadingView() {
        blurView.contentView.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = .white
        loadingView.layer.cornerRadius = 75
        loadingView.layer.masksToBounds = true
        let constraints = [
            loadingView.centerYAnchor.constraint(equalTo: window.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 150),
            loadingView.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupAnimationView() {
        loadingView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.animation = Animation.named("loadingAnimation")
        animationView.play()
        animationView.loopMode = .loop
        let constraints = [
            animationView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 300),
            animationView.heightAnchor.constraint(equalToConstant: 300)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLoadingLabel() {
        loadingView.addSubview(loadingLabel)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.text = "LOADING"
        loadingLabel.font = UIFont.boldSystemFont(ofSize: 16)
        loadingLabel.textColor = ThemeColors.mainColor
        let constraints = [
            loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingLabel.bottomAnchor.constraint(equalTo: loadingView.bottomAnchor, constant: -18),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
