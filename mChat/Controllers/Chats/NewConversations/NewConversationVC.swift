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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFriends()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        friendsList = []
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(NewConversationCell.self, forCellReuseIdentifier: "NewConversationCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
                   Constants.db.reference().child("users").child(dict).observe(.value) { (data) in
                       guard let values = data.value as? [String: Any] else { return }
                       let friend = FriendInfo()
                       friend.id = dict
                       friend.email = values["email"] as? String
                       friend.profileImage = values["profileImage"] as? String
                       friend.name = values["name"] as? String
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
        let controller = ChatVC()
        controller.modalPresentationStyle = .fullScreen
        controller.friendEmail = friend.email
        controller.friendProfileImage = friend.profileImage
        controller.friendName = friend.name
        controller.friendId = friend.id
        show(controller, sender: nil)
    }
    
}
