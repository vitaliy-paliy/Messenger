//
//  RequestButtonView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/8/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class RequestButtonView: UIButton {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var controller: ContactsVC!
    let circleView = UIView()
    let requestNumLabel = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //s
    
    init(_ controller: ContactsVC) {
        super.init(frame: .zero)
        self.controller = controller
        setupButton()
        setupCircleView()
        setupRequestNumberLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupButton() {
        setImage(UIImage(systemName: "person.2.fill"), for: .normal)
        tintColor = .black
        addTarget(controller, action: #selector(controller.friendRequestPressed), for: .touchUpInside)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupCircleView() {
        addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.backgroundColor = .red
        circleView.layer.cornerRadius = 9
        circleView.layer.masksToBounds = true
        circleView.isHidden = true
        let constraints = [
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 14),
            circleView.topAnchor.constraint(equalTo: topAnchor, constant: -10),
            circleView.widthAnchor.constraint(equalToConstant: 18),
            circleView.heightAnchor.constraint(equalToConstant: 18),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupRequestNumberLabel() {
        circleView.addSubview(requestNumLabel)
        requestNumLabel.translatesAutoresizingMaskIntoConstraints = false
        requestNumLabel.textColor = .white
        requestNumLabel.font = UIFont.boldSystemFont(ofSize: 12)
        let constraints = [
            requestNumLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            requestNumLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}



