//
//  MessageLoadingIndicator.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/31/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class MessageLoadingIndicator: UIActivityIndicatorView {

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var const: CGFloat!
    var chatVC: ChatVC!
    var order: Bool!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(frame: CGRect, const: CGFloat, chatVC: ChatVC) {
        super.init(frame: frame)
        self.const = const
        self.chatVC = chatVC
        setupIndicator()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupIndicator(){
        hidesWhenStopped = true
        var topConst: CGFloat = 90
        if const == 8 {
            topConst = 70
        }
        color = .black
        chatVC.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            centerXAnchor.constraint(equalTo: chatVC.view.centerXAnchor),
            topAnchor.constraint(equalTo: chatVC.view.topAnchor, constant: topConst),
            widthAnchor.constraint(equalToConstant: 25),
            heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

