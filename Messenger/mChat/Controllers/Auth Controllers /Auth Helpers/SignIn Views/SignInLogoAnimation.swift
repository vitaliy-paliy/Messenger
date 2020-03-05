//
//  SignInLogoAnimation.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/27/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class SignInLogoAnimation: UIImageView {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var logoView = UIView()
    var controller: SignInVC!
    let logoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    let logoTransitionView = UIView()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(_ controller: SignInVC) {
        super.init(frame: .zero)
        self.controller = controller
        setupLogoView()
        animateTransition()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLogoView() {
        controller.view.addSubview(logoView)
        logoView.backgroundColor = .white
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.layer.cornerRadius = 50
        logoView.layer.masksToBounds = true
        let constraints = [
            logoView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: controller.view.topAnchor, constant: controller.view.frame.height/6),
            logoView.widthAnchor.constraint(equalToConstant: 100),
            logoView.heightAnchor.constraint(equalToConstant: 100),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLogo(){
        frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        controller.view.addSubview(self)
        center = CGPoint(x: controller.view.center.x, y: controller.view.center.y)
        image = UIImage(named: "Logo-Light")
        contentMode = .scaleAspectFill
        layer.cornerRadius = 100
        layer.masksToBounds = true
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLogoTransitionView(){
        logoTransitionView.frame = controller.view.frame
        let gradient = controller.setupGradientLayer()
        gradient.frame = controller.view.frame
        logoTransitionView.layer.addSublayer(gradient)
        controller.view.addSubview(logoTransitionView)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLogoLabel() {
        logoLabel.center = CGPoint(x: controller.view.center.x, y: controller.view.center.y + 150)
        logoLabel.font = UIFont(name: "Alata", size: 48)
        logoLabel.text = "mChat"
        logoLabel.textAlignment = .center
        logoLabel.textColor = .white
        controller.view.addSubview(logoLabel)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func animateTransition() {
        setupLogoTransitionView()
        setupLogo()
        setupLogoLabel()
        let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(animateLogo), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .default)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func animateLogo(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.layer.cornerRadius = 45
            self.frame.size = CGSize(width: 90, height: 90)
            self.center = CGPoint(x: self.logoView.center.x, y: self.logoView.center.y)
            self.logoTransitionView.alpha = 0
            self.logoLabel.alpha = 0
        }) { (true) in
            self.logoTransitionView.removeFromSuperview()
            self.logoLabel.removeFromSuperview()
        }
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
