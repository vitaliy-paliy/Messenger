//
//  AuthBackButton.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/27/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class AuthBackButton: UIButton {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var controller: UIViewController!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(_ controller: UIViewController) {
        super.init(frame: .zero)
        self.controller = controller
        setupBackButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupBackButton() {
        controller.view.addSubview(self)
        setBackgroundImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        tintColor = .white
        let constraints = [
            leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 16),
            topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            widthAnchor.constraint(equalToConstant: 30),
            heightAnchor.constraint(equalToConstant: 30),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
