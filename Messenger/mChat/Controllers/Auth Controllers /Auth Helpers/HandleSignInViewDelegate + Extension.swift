//
//  HandleSignInViewDelegate + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/27/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //

protocol HandleSignInView {
    func returnToSignInVC()
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //

extension SignInVC: HandleSignInView {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func returnToSignInVC() {
        for subview in loginView.subviews {
            subview.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        loginButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            for subview in self.loginView.subviews {
                subview.transform = .identity
                subview.alpha = 1
                self.loginButton.alpha = 1
                self.loginButton.transform = .identity
            }
        })
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
