//
//  FriendRequestVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/5/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Lottie

class FriendRequestVC: UIViewController {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let tableView = UITableView()
    var friendRequests = [FriendInfo]()
    let friendRequestNetworking = FriendRequestNetworking()
    let blankLoadingView = AnimationView(animation: Animation.named("blankLoadingAnim"))
    let emptyLabel = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequests()
        view.backgroundColor = .red
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Friend Requests"
        setupTableView()
        setupBlankView(blankLoadingView)
        setupEmptyView()
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
    
    private func setupEmptyView() {
        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.textColor = .gray
        emptyLabel.font = UIFont.boldSystemFont(ofSize: 24)
        emptyLabel.text = "EMPTY"
        emptyLabel.isHidden = true
        let constraints = [
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func fetchRequests() {
        friendRequestNetworking.controller = self
        friendRequestNetworking.setupFriendRequests {
            if self.friendRequestNetworking.friendKeys.count == 0 {
                self.emptyLabel.isHidden = false
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(FriendRequestCell.self, forCellReuseIdentifier: "FriendRequestCell")
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
     
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func addButtonPressed(cell: FriendRequestCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let friend = friendRequests[indexPath.row]
        friendRequestNetworking.addAsFriend(friend) {
            self.friendRequests.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func declineButtonPressed(cell: FriendRequestCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let userToDelete = friendRequests[indexPath.row]
        friendRequestNetworking.declineUser(userToDelete) {
            self.friendRequests.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

extension FriendRequestVC: UITableViewDataSource, UITableViewDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell") as! FriendRequestCell
        cell.controller = self
        let user = friendRequests[indexPath.row]
        cell.nameLabel.text = user.name?.uppercased()
        cell.emailLabel.text = user.email?.uppercased()
        cell.profileImage.loadImage(url: user.profileImage ?? "")
        return cell
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
