//
//  ConversationsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ConversationsVC: UIViewController {
    
    var messages = [Messages]()
    var recentMessages = [String: Messages]()
    var friends = [FriendInfo]()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        view.backgroundColor = .white
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        messages = []
        friends = []
    }
    
    func loadMessages(){
        let ref = Database.database().reference().child("messagesIds").child(CurrentUser.uid)
        ref.observe(.childAdded) { (snap) in
            let messagesId = snap.key
            print("hi")
            let db = Database.database().reference().child("messages").child(messagesId)
            db.observeSingleEvent(of: .value) { (data) in
                guard let values = data.value as? [String: Any] else { return }
                print(values)
                let message = Messages()
                message.sender = values["sender"] as? String
                message.recipient = values["recipient"] as? String
                message.message = values["message"] as? String
                message.time = values["time"] as? NSNumber
                if let recipient = message.recipient {
                    self.recentMessages[recipient] = message
                    self.messages = Array(self.recentMessages.values)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConversationsCell.self, forCellReuseIdentifier: "ConversationsCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ConversationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationsCell") as! ConversationsCell
        let recent = messages[indexPath.row]
        let user: String?
        if recent.sender == CurrentUser.uid {
            user = recent.recipient
        }else{
            user = recent.sender
        }
        if let id = user {
            let ref = Constants.db.reference().child("users").child(id)
            ref.observeSingleEvent(of: .value) { (snap) in
                guard let values = snap.value as? [String: Any] else { return }
                let friend = FriendInfo()
                friend.email = values["email"] as? String
                friend.id = id
                friend.name = values["name"] as? String
                friend.profileImage = values["profileImage"] as? String
                cell.friendName.text = friend.name
                cell.profileImage.loadImage(url: friend.profileImage)
                self.friends.append(friend)
            }
        }
        cell.recentMessage.text = recent.message
        print(messages.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
