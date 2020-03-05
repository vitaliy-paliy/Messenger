//
//  NavigationItem + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/10/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Lottie

extension UINavigationItem {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // EXTENSION FOR SETTING UP CHAT NAVIGATION BAR
    
    func setNavTitles(navTitle: String, navSubtitle: String){
        let title = setupTitleLabel(navTitle)
        let subtitle = UILabel()

        subtitle.text = navSubtitle
        subtitle.font = UIFont(name: "Helvetica Neue", size: 14)
        subtitle.textColor = .lightGray
        
        let stackView = setupStackView(view1: title, view2: subtitle)
        
        titleView = stackView
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupTypingNavTitle(navTitle: String){
        let title = setupTitleLabel(navTitle)
        let animationView = UIView()
        let animation = setupAnimationView()
        let typingLabel = setupTypingLabel()
        animationView.addSubview(animation)
        animationView.addSubview(typingLabel)
        typingLabel.translatesAutoresizingMaskIntoConstraints = false
        animation.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            animation.widthAnchor.constraint(equalToConstant: 60),
            animation.heightAnchor.constraint(equalToConstant: 60),
            animation.trailingAnchor.constraint(equalTo: animationView.centerXAnchor, constant: 4),
            animation.centerYAnchor.constraint(equalTo: animationView.centerYAnchor),
            typingLabel.centerYAnchor.constraint(equalTo: animation.centerYAnchor),
            typingLabel.leadingAnchor.constraint(equalTo: animationView.centerXAnchor, constant: -4),
        ]
        NSLayoutConstraint.activate(constraints)
        let stackView = setupStackView(view1: title, view2: animationView)
        titleView = stackView
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTitleLabel(_ text: String) -> UILabel{
        let title = UILabel()
        title.text = text
        title.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        return title
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupAnimationView() -> AnimationView{
        let typingAnimation = AnimationView()
        typingAnimation.animationSpeed = 1.2
        typingAnimation.animation = Animation.named("chatTyping")
        typingAnimation.play()
        typingAnimation.loopMode = .loop
        typingAnimation.backgroundBehavior = .pauseAndRestore
        return typingAnimation
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTypingLabel() -> UILabel{
        let typingLabel = UILabel()
        typingLabel.text = "typing".uppercased()
        typingLabel.font = UIFont.boldSystemFont(ofSize: 13)
        typingLabel.textColor = .gray
        return typingLabel
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupStackView(view1: UIView, view2: UIView) -> UIStackView{
        let stackView = UIStackView(arrangedSubviews: [view1, view2])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .center
        let width = max(view1.frame.size.width, view2.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 25)
        view1.sizeToFit()
        view2.sizeToFit()
        return stackView
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
