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
    var friendsList = [String]()
    var filteredFriends = [String: FriendInfo]()
    var tableView = UITableView()
    var timer = Timer()
    let calendar = Calendar(identifier: .gregorian)
    var newConversationButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        view.backgroundColor = .white
        setupNewConversationButton()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFriendListHandler()
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
    
    func loadFriendListHandler(){
        Constants.db.reference().child("friendsList").child(CurrentUser.uid).observe(.value) { (snap) in
            self.recentMessages = [:]
            self.friends = []
            self.friendsList = []
            guard let friend = snap.value as? [String: Any] else {
                DispatchQueue.main.async {
                    self.messages = []
                    self.tableView.reloadData()
                }
                return
            }
            for key in friend.keys{
                self.friendsList.append(key)
            }
            self.observeMessageIds()
        }
    }
    
    func observeMessageIds(){
        let nodeRef = Database.database().reference().child("message-Ids").child(CurrentUser.uid)
        nodeRef.observe(.childAdded) { (snap) in
            if !self.friendsList.contains(snap.key) { return }
            let userMRef = Database.database().reference().child("message-Ids").child(CurrentUser.uid).child(snap.key)
            userMRef.observe(.childAdded) { (userSnap) in
                self.messagesReference(userSnap.key)
            }
        }
    }
    
    func messagesReference(_ key: String){
        Database.database().reference().child("messages").child(key).observe(.value) { (snapshot) in
            guard let values = snapshot.value as? [String: Any] else { return }
            self.loadMessagesHandler(values)
        }
    }
    
    func loadMessagesHandler(_ values: [String: Any]) {
        let message = Messages()
        message.sender = values["sender"] as? String
        message.recipient = values["recipient"] as? String
        message.message = values["message"] as? String
        message.time = values["time"] as? NSNumber
        message.mediaUrl = values["mediaUrl"] as? String
        let user = message.determineUser()
        recentMessages[user] = message
        messages = Array(recentMessages.values)
        messages.sort { (message1, message2) -> Bool in
            return message1.time.intValue > message2.time.intValue
        }
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
    }
    
    @objc func handleReload(){
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        let user = recent.determineUser()
        let ref = Database.database().reference().child("users").child(user)
        ref.observe(.value) { (snap) in
            guard let data = snap.value as? [String: Any] else { return }
            let friend = FriendInfo()
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
//        print(indexPath.row)
        cell.selectionStyle = .none
        let recent = messages[indexPath.row]
        loadFriendsHandler(recent, cell) { (friend) in
            cell.friendName.text = friend.name
            cell.profileImage.loadImage(url: friend.profileImage)
            self.observeIsUserTyping(friendId: friend.id, cell: cell)
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
