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
    var timer = Timer()
    let calendar = Calendar(identifier: .gregorian)
    var newConversationButton = UIBarButtonItem()
    var friendActivity = [FriendActivity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        view.backgroundColor = .white
        setupNewConversationButton()
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
    
    func loadMessages(){
        recentMessages = [:]
        Constants.db.reference().child("friendsList").child(CurrentUser.uid).observeSingleEvent(of: .value) { (snap) in
            guard let friend = snap.value as? [String: Any] else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
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
        let ref = Database.database().reference().child("messagesIds").child(CurrentUser.uid)
        ref.observe(.childAdded) { (snap) in
            let messagesId = snap.key
            let db = Database.database().reference().child("messages").child(messagesId)
            db.observe(.value) { (data) in
                guard let values = data.value as? [String: Any] else { return }
                let message = Messages()
                message.sender = values["sender"] as? String
                message.recipient = values["recipient"] as? String
                message.message = values["message"] as? String
                message.time = values["time"] as? NSNumber
                if key == message.determineUser() {
                    self.recentMessages[message.determineUser()] = message
                    self.messages = Array(self.recentMessages.values)
                    self.messages.sort { (message1, message2) -> Bool in
                        return message1.time.intValue > message2.time.intValue
                    }
                    self.timer.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
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
    
    func observeIsUserTyping(friendId: String, cell: ConversationsCell){
        let db = Database.database().reference().child("userActions").child(friendId).child(CurrentUser.uid)
        db.observe(.value) { (snap) in
            guard let data = snap.value as? [String: Any] else { return }
            print(friendId)
            let activity = FriendActivity()
            activity.friendId = data["fromFriend"] as? String
            activity.isTyping = data["isTyping"] as? Bool
            self.friendActivity = [activity]
            guard self.friendActivity.count == 1 else { return }
            let friendActivity = self.friendActivity[0]
            if cell.typingAnimation.isAnimationPlaying == false {
                cell.typingAnimation.play()
            }
            if friendId == friendActivity.friendId && friendActivity.isTyping {
                cell.recentMessage.isHidden = true
                cell.timeLabel.isHidden = true
                cell.isTypingView.isHidden = false
            }else{
                cell.recentMessage.isHidden = false
                cell.timeLabel.isHidden = false
                cell.isTypingView.isHidden = true
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
        let recent = messages[indexPath.row]
        let user = recent.determineUser()
        let ref = Constants.db.reference().child("users").child(user)
        ref.observeSingleEvent(of: .value) { (snap) in
            guard let values = snap.value as? [String: Any] else { return }
            let friend = FriendInfo()
            friend.email = values["email"] as? String
            friend.id = user
            friend.isOnline = values ["isOnline"] as? Bool
            friend.lastLogin = values["lastLogin"] as? NSNumber
            friend.name = values["name"] as? String
            friend.profileImage = values["profileImage"] as? String
            cell.friendName.text = friend.name
            cell.profileImage.loadImage(url: friend.profileImage)
            if recent.message != nil {
                cell.recentMessage.text = recent.message
            }else{
                cell.recentMessage.text = "[Media Message]"
            }
            if friend.isOnline {
                cell.isOnlineView.isHidden = false
            }else{
                cell.isOnlineView.isHidden = true
            }
            let date = NSDate(timeIntervalSince1970: recent.time.doubleValue)
            cell.timeLabel.text = "\(self.calendar.calculateTimePassed(date: date))"
            self.friends.append(friend)
            self.observeIsUserTyping(friendId: friend.id, cell: cell)
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
