//
//  ConversationsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

protocol NewConversationSelected {
    func showSelectedUser(selectedFriend: FriendInfo)
}

class ConversationsVC: UIViewController {
    
    var convNetworking = ConversationsNetworking()
    var messages = [Messages]()
    var groupedMessages = [String: Messages]()
    var friends = [FriendInfo]()
    var filteredFriends = [String: FriendInfo]()
    var tableView = UITableView()
    var timer = Timer()
    let calendar = Calendar(identifier: .gregorian)
    var newConversationButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        view.backgroundColor = .white
        loadConversations()
        setupNewConversationButton()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(ConversationsCell.self, forCellReuseIdentifier: "ConversationsCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupNewConversationButton(){
        newConversationButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(newConversationTapped))
        newConversationButton.tintColor = .black
        navigationItem.rightBarButtonItem = newConversationButton
    }
    
    @objc func newConversationTapped(){
        let controller = NewConversationVC()
        controller.conversationDelegate = self
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func loadConversations(){
        convNetworking.convVC = self
        convNetworking.observeFriendsList()
    }
    
    func loadMessagesHandler(_ newMessages: [Messages]?) {
        if let newMessages = newMessages {
            handleReload(newMessages)
        }
        observeMessageActions()
    }
    
    func handleReload(_ newMessages: [Messages]){
        messages = newMessages
        messages.sort { (message1, message2) -> Bool in
            return message1.time.intValue > message2.time.intValue
        }
        tableView.reloadData()
    }
    
    func observeMessageActions(){
        convNetworking.observeNewMessages { (newMessages) in
            self.handleReload(newMessages)
        }
    }
    
    func nextControllerHandler(usr: FriendInfo){
        let controller = ChatVC()
        controller.modalPresentationStyle = .fullScreen
        controller.friend = usr
        show(controller, sender: nil)
    }
    
    func loadFriendsHandler(_ recent: Messages, _ cell: ConversationsCell, completion: @escaping (_ friend: FriendInfo) -> Void){
        let user = recent.determineUser()
        let ref = Database.database().reference().child("users").child(user)
        ref.observe(.value) { (snap) in
            guard let data = snap.value as? [String: Any] else { return }
            var friend = FriendInfo()
            friend.id = snap.key
            friend.name = data["name"] as? String
            friend.email = data["email"] as? String
            friend.isOnline = data["isOnline"] as? Bool
            friend.lastLogin = data["lastLogin"] as? NSNumber
            friend.profileImage = data["profileImage"] as? String
            self.filteredFriends[user] = friend
            self.friends = Array(self.filteredFriends.values)
            return completion(friend)
        }
    }
    
    func observeIsUserTyping(friendId: String, cell: ConversationsCell){
        let db = Database.database().reference().child("userActions").child(friendId).child(CurrentUser.uid)
        db.observe(.value) { (snap) in
            guard let data = snap.value as? [String: Any] else { return }
            guard let status = data["isTyping"] as? Bool else { return }
            guard let id = data["fromFriend"] as? String else { return }
            let friendActivity = FriendActivity(isTyping: status, friendId: id)
            print(friendId)
            if friendActivity.friendId == friendId && friendActivity.isTyping {
//                print(friendId)
                cell.recentMessage.isHidden = true
                cell.timeLabel.isHidden = true
                cell.isTypingView.isHidden = false
            }else{
                cell.isTypingView.isHidden = true
                cell.recentMessage.isHidden = false
                cell.timeLabel.isHidden = false
            }
        }
    }
    
}

extension ConversationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationsCell") as! ConversationsCell
        cell.selectionStyle = .none
        let recent = messages[indexPath.row]
        observeIsUserTyping(friendId: recent.determineUser(), cell: cell)
        loadFriendsHandler(recent, cell) { (friend) in
            cell.friendName.text = friend.name
            cell.profileImage.loadImage(url: friend.profileImage)
            if friend.isOnline{
                cell.isOnlineView.isHidden = false
            }else{
                cell.isOnlineView.isHidden = true
            }
        }
        let date = NSDate(timeIntervalSince1970: recent.time.doubleValue)
        cell.timeLabel.text = calendar.calculateTimePassed(date: date)
        if recent.mediaUrl != nil {
            cell.recentMessage.text = "[Media Message]"
        }else if recent.audioUrl != nil {
            cell.recentMessage.text = "[Audio Message]"
        }else{
            cell.recentMessage.text = recent.message
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chat = messages[indexPath.row]
        var user: String?
        if chat.recipient == CurrentUser.uid{
            user = chat.sender
            for usr in friends {
                if usr.id == user {
                    nextControllerHandler(usr: usr)
                    break
                }
            }
        }else{
            user = chat.recipient
            for usr in friends {
                if usr.id == user {
                    nextControllerHandler(usr: usr)
                    break
                }
            }
        }
    }
    
}

extension ConversationsVC: NewConversationSelected {
    
    func showSelectedUser(selectedFriend: FriendInfo) {
        nextControllerHandler(usr: selectedFriend)
    }
    
}
