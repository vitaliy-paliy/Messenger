//
//  CurrentUserVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/25/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class CurrentUserVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    
}
