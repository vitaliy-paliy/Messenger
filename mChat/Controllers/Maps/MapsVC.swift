//
//  MapsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/8/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class MapsVC: UIViewController {
    
    var friends = [FriendInfo]()
    var exitButton = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupExitButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupExitButton(){
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        exitButton.tintColor = .white
        exitButton.layer.shadowRadius = 10
        exitButton.layer.shadowOpacity = 0.5
        exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        let constraints = [
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func exitButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
}
