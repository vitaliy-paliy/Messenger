//
 //  ContactsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Lottie

class ContactsVC: UIViewController {

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // CONTACTS VC - USER'S FRIENDS LIST IS LOCATED HERE.
    
    let contactsNetworking = ContactsNetworking()
    let tableView = UITableView()
    let blurView = UIVisualEffectView()
    var infoMenuView: InfoMenuView!
    var tabBarBadge: UITabBarItem!
    var requestButtonView: RequestButtonView!
    let blankLoadingView = AnimationView(animation: Animation.named("blankLoadingAnim"))
    var emptyListView: EmptyListView!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Friends.list = []
        contactsNetworking.contactsVC = self
        contactsNetworking.observeFriendList()
        if let tabItems = tabBarController?.tabBar.items {
            tabBarBadge = tabItems[0]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: SETUP UI METHOD
    
    private func setupUI(){
        navigationItem.title = "Contacts"
        view.backgroundColor = .white
        setupTableView()
        emptyListView = EmptyListView(self, nil , true)
        setupBlankView(blankLoadingView)
        setupaddButton()
        setupFriendRequest()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView(){
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: HANDLE RELOAD METHOD
    
    func handleReload(_ friends: [FriendInfo]){
        Friends.list = friends
        Friends.list.sort { (friend1, friend2) -> Bool in
            return friend1.name ?? "" < friend2.name ?? ""
        }
        handleEmptyList()
        Friends.convVC?.tableView.reloadData()
        self.tableView.reloadData()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func handleEmptyList() {
        emptyListView.isHidden = !(Friends.list.count == 0)
        emptyListView.emptyButton.isHidden = !(Friends.list.count == 0)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupaddButton() {
        var addButton = UIBarButtonItem()
        let buttonView = UIButton()
        buttonView.setImage(UIImage(systemName: "plus"), for: .normal)
        buttonView.tintColor = .black
        buttonView.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton = UIBarButtonItem(customView: buttonView)
        navigationItem.rightBarButtonItem = addButton
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupFriendRequest() {
        requestButtonView = RequestButtonView(self)
        let requestButton = UIBarButtonItem(customView: requestButtonView)
        navigationItem.leftBarButtonItem = requestButton
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: FRIEND REQUEST HANDLER
    
    @objc func friendRequestPressed() {
        let friendRequestVC = FriendRequestVC()
        show(friendRequestVC, sender: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: ADD BUTTON HANDLER
    
    @objc func addButtonPressed(){
        let controller = UsersListVC()
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupFriendInfoMenuView(_ cell: ContactsCell, cellFrame: CGRect, friend: FriendInfo){
        cell.isHidden = true
        tableView.isUserInteractionEnabled = false
        infoMenuView = InfoMenuView(cell: cell, cellFrame: cellFrame, friend: friend, contactsVC: self)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupContactsBadge(_ numOfRequests: Int) {
        tabBarBadge.badgeValue = nil
        requestButtonView.circleView.isHidden = false
        if numOfRequests == 0 {
            requestButtonView.circleView.isHidden = true
            return
        }else if numOfRequests > 9 {
            requestButtonView.requestNumLabel.text = "+9"
        }
        
        tabBarBadge.badgeValue = "\(numOfRequests)"
        requestButtonView.requestNumLabel.text = "\(numOfRequests)"
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

