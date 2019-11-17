//
//  ChatTabBar.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ChatTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func setupVC(){
        let chats = UINavigationController(rootViewController: ChatsVC())
        let contacts = UINavigationController(rootViewController: ContactsVC())
        let settings = UINavigationController(rootViewController: SettingsVC())
        chats.title = "Chats"
        contacts.title = "Contacts"
        settings.title = "Settings"
        viewControllers = [contacts,chats,settings]
    }
    
}
