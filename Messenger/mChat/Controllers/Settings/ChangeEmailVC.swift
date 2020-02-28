//
//  ChangeEmailVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/27/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Lottie

class ChangeEmailVC: UIViewController {
    
    var infoAnimView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        navigationItem.title = "Change Email"
        setupChangeInfoAnim()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupChangeInfoAnim() {
        view.addSubview(infoAnimView)
        infoAnimView.translatesAutoresizingMaskIntoConstraints = false
        infoAnimView.animation = Animation.named("changeInfo_anim")
        infoAnimView.loopMode = .loop
        infoAnimView.play()
        infoAnimView.backgroundBehavior = .pauseAndRestore
        let constraints = [
            infoAnimView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoAnimView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            infoAnimView.widthAnchor.constraint(equalToConstant: 250),
            infoAnimView.heightAnchor.constraint(equalToConstant: 250),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}


