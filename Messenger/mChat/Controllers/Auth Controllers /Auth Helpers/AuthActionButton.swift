//
//  AuthActionButton.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/27/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class AuthActionButton: UIButton {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var controller: UIViewController!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(_ title: String, _ controller: UIViewController) {
        super.init(frame: .zero)
        self.controller = controller
        setupContinueButton(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupContinueButton(_ title: String) {
        frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        tintColor = .white
        layer.cornerRadius = 18
        layer.masksToBounds = true
        let gradient = controller.setupGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradient, at: 0)
    }
        
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
