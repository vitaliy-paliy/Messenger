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
    var filteredFriends = [String: FriendInfo]()
    var tableView = UITableView()
    var timer = Timer()
    let calendar = Calendar(identifier: .gregorian)
    var newConversationButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        view.backgroundColor = .white
        friendListHandler()
        setupNewConversationButton()
        setupTableView()
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
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
    
    func friendListHandler(){
        Constants.db.reference().child("friendsList").child(CurrentUser.uid).observe(.value) { (snap) in
            guard let friend = snap.value as? [String: Any] else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            self.recentMessages = [:]
            for key in friend.keys{
                self.loadMessagesHandler(key)
            }
        }
    }
    
    @objc func handleReload(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadMessagesHandler(_ key: String){
        let nodeRef = Database.database().reference().child("message-Ids").child(CurrentUser.uid)
        nodeRef.observe(.childAdded) { (snap) in
            Database.database().reference().child("messages").child(snap.key).observe(.value) { (snapshot) in
                guard let values = snapshot.value as? [String: Any] else { return }
                let message = Messages()
                message.sender = values["sender"] as? String
                message.recipient = values["recipient"] as? String
                message.message = values["message"] as? String
                message.time = values["time"] as? NSNumber
                message.mediaUrl = values["mediaUrl"] as? String
                if key == message.determineUser() {
                    self.recentMessages[message.determineUser()] = message
                    self.messages = Array(self.recentMessages.values)
                    self.messages.sort { (message1, message2) -> Bool in
                        return message1.time.intValue > message2.time.intValue
                    }
                    self.handleReload()
                }
            }
        }
    }
    
    func nextControllerHandler(usr: FriendInfo){
        let controller = ChatVC()
        controller.modalPresentationStyle = .fullScreen
        controller.friendName = usr.name
        controller.friendEmail = usr.email
        controller.friendProfileImage = usr.profileImage
        controller.friendId = usr.id
        controller.friendIsOnline = usr.isOnline
        controller.friendLastLogin = usr.lastLogin
        show(controller, sender: nil)
    }
    
    func loadFriendsHandler(_ recent: Messages, _ cell: ConversationsCell, completion: @escaping (_ friend: FriendInfo) -> Void){
        let ref = Database.database().reference().child("users").child(recent.determineUser())
        ref.observe(.value) { (snap) in
            guard let data = snap.value as? [String: Any] else { return }
            let friend = FriendInfo()
            friend.id = snap.key
            friend.name = data["name"] as? String
            friend.email = data["email"] as? String
            friend.isOnline = data["isOnline"] as? Bool
            friend.lastLogin = data["lastLogin"] as? NSNumber
            friend.profileImage = data["profileImage"] as? String
            self.filteredFriends[recent.determineUser()] = friend
            self.friends = Array(self.filteredFriends.values)
            return completion(friend)
        }
    }
    
    func observeIsUserTyping(friendId: String, cell: ConversationsCell){
        
        let db = Database.database().reference().child("userActions").child(friendId).child(CurrentUser.uid)
        db.observe(.value) { (snap) in
            self.hideAnimationViews(cell)
            guard let data = snap.value as? [String: Any] else { return }
            let activity = FriendActivity()
            activity.friendId = data["fromFriend"] as? String
            activity.isTyping = data["isTyping"] as? Bool
            if activity.friendId == friendId && activity.isTyping {
                cell.recentMessage.isHidden = true
                cell.timeLabel.isHidden = true
                cell.isTypingView.isHidden = false
            }else{
                self.hideAnimationViews(cell)
            }
        }
    }
    
    func hideAnimationViews(_ cell: ConversationsCell){
        cell.isTypingView.isHidden = true
        cell.recentMessage.isHidden = false
        cell.timeLabel.isHidden = false
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
        loadFriendsHandler(recent, cell) { (friend) in
            cell.friendName.text = friend.name
            cell.profileImage.loadImage(url: friend.profileImage)
            self.observeIsUserTyping(friendId: friend.id, cell: cell)
        }
        let date = NSDate(timeIntervalSince1970: recent.time.doubleValue)
        cell.timeLabel.text = calendar.calculateTimePassed(date: date)
        if recent.mediaUrl != nil {
            cell.recentMessage.text = "[Media Message]"
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
