//
//  RequestButtonView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/8/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class RequestButtonView: UIButton {
    
    class func setupButton(_ controller: ContactsVC) -> RequestButtonView {
        let button = RequestButtonView(type: .system)
        button.setImage(UIImage(systemName: "person.2.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(controller, action: #selector(controller.friendRequestPressed), for: .touchUpInside)
        return button
    }

}



