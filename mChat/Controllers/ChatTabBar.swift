//
//  ChatTabBar.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ChatTabBar: UITabBarController{
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        
    }
    
    func setupVC(){
        let chats = UINavigationController(rootViewController: ChatsVC())
        let contacts = UINavigationController(rootViewController: ContactsVC())
        let settings = UINavigationController(rootViewController: SettingsVC())
        chats.title = "Chats"
        chats.tabBarItem.image = UIImage(systemName: "message.fill")
        contacts.title = "Contacts"
        contacts.tabBarItem.image = UIImage(systemName: "person.fill")
        settings.title = "Settings"
        settings.tabBarItem.image = UIImage(systemName: "gear")
        viewControllers = [contacts,chats,settings]
    }
    
}
