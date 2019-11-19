//
//  UsersListVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/18/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class UsersListVC: UIViewController {

    var users: [UserInfo] = []
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        fetchUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
 
    func fetchUsers(){
        Constants.db.reference().child("users").observe(.childAdded) { (snapshot) in
            let user = UserInfo()
            guard let values = snapshot.value as? [String: Any] else { return }
            user.email = values["email"] as? String
            user.profileImage = values["profileImage"] as? String
            user.name = values["name"] as? String
            user.id = snapshot.key
            self.users.append(user)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.register(UsersListCell.self, forCellReuseIdentifier: "UsersListCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension UsersListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersListCell") as! UsersListCell
        let user = users[indexPath.row]
        cell.userName.text = user.name
        cell.userEmail.text = user.email
        cell.profileImage.loadImage(url: user.profileImage!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = AddFriendVC()
        controller.email = selectedUser.email
        controller.name = selectedUser.name
        controller.friendId = selectedUser.id
        controller.profileImage = selectedUser.profileImage
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
}
