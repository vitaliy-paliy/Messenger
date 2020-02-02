//
//  NewConversationVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/1/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class NewConversationVC: UIViewController {
    
    var friendsList = [FriendInfo]()
    var tableView = UITableView()
    var timer = Timer()
    var forwardDelegate: ChatVC!
    var conversationDelegate: ConversationsVC!
    var forwardName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriends()
        setupForwardView()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupForwardView(){
        navigationItem.title = forwardName != nil ? "Forward" : "New Conversation"
        let leftButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func cancelButtonPressed(){
        forwardDelegate?.userResponse.messageToForward = nil
        forwardDelegate?.userResponse.messageSender = nil
        dismiss(animated: true, completion: nil)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(NewConversationCell.self, forCellReuseIdentifier: "NewConversationCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func loadFriends(){
        Constants.db.reference().child("friendsList").child(CurrentUser.uid).observeSingleEvent(of: .value) { (snap) in
            guard let friends = snap.value as? [String: Any] else {
                self.friendsList = []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            for dict in friends.keys {
                Constants.db.reference().child("users").child(dict).observeSingleEvent(of: .value) { (data) in
                    guard let values = data.value as? [String: Any] else { return }
                    var friend = FriendInfo()
                    friend.id = dict
                    friend.email = values["email"] as? String
                    friend.profileImage = values["profileImage"] as? String
                    friend.name = values["name"] as? String
                    friend.isOnline = values["isOnline"] as? Bool
                    friend.lastLogin = values["lastLogin"] as? NSNumber
                    self.friendsList.append(friend)
                    self.friendsList.sort { (friend1, friend2) -> Bool in
                        return friend1.name < friend2.name
                    }
                    self.timer.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    @objc func handleReload(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension NewConversationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewConversationCell") as! NewConversationCell
        cell.selectionStyle = .none
        let friend = friendsList[indexPath.row]
        cell.profileImage.loadImage(url: friend.profileImage)
        cell.friendName.text = friend.name
        cell.friendEmail.text = friend.email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friendsList[indexPath.row]
        if let name = forwardName {
            forwardDelegate?.forwardToSelectedFriend(friend: friend, for: name)
            dismiss(animated: true, completion: nil)
            return
        }
        conversationDelegate.showSelectedUser(selectedFriend: friend)
        dismiss(animated: true, completion: nil)
    }
    
}
