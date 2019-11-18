//
//  SettingsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    var leftBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        view.backgroundColor = .white
        setupLeftNavButton()
    }
    
    func setupLeftNavButton(){
        leftBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(logoutButtonPressed))
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc func logoutButtonPressed(){
        do{
            try Auth.auth().signOut()
            let controller = SignInVC()
            view.window?.rootViewController = controller
            view.window?.makeKeyAndVisible()
        }catch{
            showAlert(title: "Error", message: error.localizedDescription)
        }
        
    }
    
}
