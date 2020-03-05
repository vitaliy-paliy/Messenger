//
//  GradientLogoView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/27/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class GradientLogoView: UIView{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // AUTH GRADIENT LOGO
    
    var controller: UIViewController!
    
    init(_ controller: UIViewController, _ showLogo: Bool) {
        super.init(frame: .zero)
        self.controller = controller
        setupGradientView()
        if showLogo {
            setupLogo()
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupGradientView() {
        controller.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 50
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        let constraints = [
            topAnchor.constraint(equalTo: controller.view.topAnchor),
            leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            bottomAnchor.constraint(equalTo: controller.view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        let gradient = setupGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: controller.view.frame.width, height: controller.view.frame.height/2)
        layer.insertSublayer(gradient, at: 0)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let topColor = UIColor(red: 100/255, green: 90/255, blue: 255/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 140/255, green: 135/255, blue: 255/255, alpha: 1).cgColor
        gradient.colors = [topColor, bottomColor]
        gradient.locations = [0, 1]
        return gradient
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupLogo() {
        let logoView = UIView()
        controller.view.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.backgroundColor = .white
        logoView.layer.cornerRadius = 50
        logoView.layer.masksToBounds = true
        let imageView = UIImageView()
        controller.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Logo-Light")
        imageView.layer.cornerRadius = 45
        imageView.layer.masksToBounds = true
        let constraints = [
            logoView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: controller.view.topAnchor, constant: controller.view.frame.height/6),
            logoView.widthAnchor.constraint(equalToConstant: 100),
            logoView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
