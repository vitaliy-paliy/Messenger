//
//  ContactsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ContactsVC: UIViewController {
    
    var contactsNetworking = ContactsNetworking()
    var friendsList = [FriendInfo]()
    var tableView = UITableView()
    var blurView = UIVisualEffectView()
    var infoMenuView: InfoMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Contacts"
        view.backgroundColor = .white
        setupTableView()
        setupaddButton()
        contactsNetworking.observeFriendList()
        contactsNetworking.contactsVC = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(ContactsCell.self, forCellReuseIdentifier: "ContactsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
        
    func handleReload(_ friends: [FriendInfo]){
        friendsList = friends
        friendsList.sort { (friend1, friend2) -> Bool in
            return friend1.name < friend2.name
        }
        self.tableView.reloadData()
    }
    
    func setupaddButton(){
        var addButton = UIBarButtonItem()
        let buttonView = UIButton(type: .system)
        buttonView.setImage(UIImage(systemName: "plus"), for: .normal)
        buttonView.tintColor = .black
        buttonView.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton = UIBarButtonItem(customView: buttonView)
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonPressed(){
        let controller = UsersListVC()
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
    
    func setupFriendInfoMenuView(_ cell: ContactsCell, cellFrame: CGRect, friend: FriendInfo){
        cell.isHidden = true
        tableView.isUserInteractionEnabled = false
        infoMenuView = InfoMenuView(cell: cell, cellFrame: cellFrame, friend: friend, contactsVC: self)
    }
    
}

