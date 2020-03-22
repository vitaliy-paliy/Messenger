//
//  UsersListVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/18/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Lottie

class UsersListVC: UIViewController {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var users = [FriendInfo]()
    let userListNetworking = UserListNetworking()
    let tableView = UITableView()
    let blankLoadingView = AnimationView(animation: Animation.named("blankLoadingAnim"))
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        setupTableView()
        getUsersList()
        setupBlankView(blankLoadingView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func getUsersList() {
        userListNetworking.fetchUsers { usersList in
            let sortedUserList = Array(usersList.values).sorted { (friend1, friend2) -> Bool in
                return friend1.name ?? "" < friend2.name ?? ""
            }
            self.users = sortedUserList
            self.blankLoadingView.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UsersListCell.self, forCellReuseIdentifier: "UsersListCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

extension UsersListVC: UITableViewDelegate, UITableViewDataSource {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersListCell") as! UsersListCell
        let user = users[indexPath.row]
        cell.userName.text = user.name
        cell.userEmail.text = user.email
        cell.profileImage.loadImage(url: user.profileImage ?? "")
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = AddFriendVC()
        controller.user = selectedUser
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
