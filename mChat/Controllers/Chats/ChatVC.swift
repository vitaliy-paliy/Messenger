//
//  ChatVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController, UITextFieldDelegate{
    
    var friendId: String!
    var friendName: String!
    var friendEmail: String!
    var friendProfileImage: String!
    var messages = [Messages]()

    var tableView = UITableView()
    var messageContainer = UIView()
    var sendButton = UIButton(type: .system)
    var messageTF = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(friendName!)"
        view.backgroundColor = .white
        setupContainer()
        setupTableView()
        setupSendButton()
        setupMessageTF()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        getMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageContainer.topAnchor,constant: -1),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupContainer(){
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.backgroundColor = .white
        view.addSubview(messageContainer)
        let topLine = UIView()
        topLine.backgroundColor = UIColor(displayP3Red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        topLine.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.addSubview(topLine)
        let constraints = [
            messageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageContainer.heightAnchor.constraint(equalToConstant: 45),
            topLine.leftAnchor.constraint(equalTo: view.leftAnchor),
            topLine.rightAnchor.constraint(equalTo: view.rightAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 0.3)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupSendButton(){
        messageContainer.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        let constraints = [
            sendButton.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: messageContainer.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            sendButton.heightAnchor.constraint(equalTo: messageContainer.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    func setupMessageTF(){
        messageContainer.addSubview(messageTF)
        messageTF.placeholder = "Write a message..."
        messageTF.layer.cornerRadius = 8
        let textPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        messageTF.font = UIFont(name: "Helvetica Neue", size: 15)
        messageTF.leftView = textPadding
        messageTF.leftViewMode = .always
        messageTF.autocapitalizationType = .none
        messageTF.layer.borderWidth = 0.1
        messageTF.layer.borderColor = UIColor.systemGray.cgColor
        messageTF.layer.masksToBounds = true
        messageTF.translatesAutoresizingMaskIntoConstraints = false
        messageTF.backgroundColor = .white
        messageTF.delegate = self
        let constraints = [
            messageTF.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 20),
            messageTF.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 0),
            messageTF.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 8),
            messageTF.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
        
    @objc func sendButtonPressed(){
        let ref = Constants.db.reference().child("messages")
        let nodeRef = ref.childByAutoId()
        guard let friendId = friendId else { return }
        guard let senderId = CurrentUser.uid else { return }
        let values = ["message": messageTF.text!, "sender": senderId, "recipient": friendId, "time": Date().timeIntervalSince1970] as [String : Any]
        nodeRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("hi")
            let userMessages = Database.database().reference().child("messagesIds").child(senderId)
            let friendMessages = Database.database().reference().child("messagesIds").child(friendId)
            let messageId = nodeRef.key
            let userValues = [messageId: 1]
            userMessages.updateChildValues(userValues)
            friendMessages.updateChildValues(userValues)
        }
        self.messageTF.text = ""
    }
    
    func getMessages(){
        let db = Database.database().reference().child("messages")
        db.observe(.childAdded) { (snap) in
            guard let values = snap.value as? [String: Any] else { return }
            let message = Messages()
            message.sender = values["sender"] as? String
            message.recipient = values["recipient"] as? String
            message.message = values["message"] as? String
            message.time = values["time"] as? NSNumber
            DispatchQueue.main.async {
                self.messages.append(message)
                self.tableView.reloadData()
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonPressed()
        return true
    }
    
}

extension ChatVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.message
        return cell
    }
    
    
}
