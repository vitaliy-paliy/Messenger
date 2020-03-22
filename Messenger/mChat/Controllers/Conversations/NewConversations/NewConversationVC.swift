//
//  NewConversationVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/1/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class NewConversationVC: UIViewController {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let tableView = UITableView()
    var forwardDelegate: ChatVC!
    var conversationDelegate: ConversationsVC!
    var forwardName: String?
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupForwardView(){
        navigationItem.title = forwardName != nil ? "Forward" : "New Conversation"
        let leftButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func cancelButtonPressed(){
        forwardDelegate?.userResponse.messageToForward = nil
        forwardDelegate?.userResponse.messageSender = nil
        dismiss(animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView() {
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

extension NewConversationVC: UITableViewDelegate, UITableViewDataSource {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Friends.list.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewConversationCell") as! NewConversationCell
        cell.selectionStyle = .none
        let friend = Friends.list[indexPath.row]
        cell.profileImage.loadImage(url: friend.profileImage ?? "")
        cell.friendName.text = friend.name
        cell.friendEmail.text = friend.email
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = Friends.list[indexPath.row]
        if let name = forwardName {
            forwardDelegate?.forwardToSelectedFriend(friend: friend, for: name)
            dismiss(animated: true, completion: nil)
            return
        }
        conversationDelegate.showSelectedUser(selectedFriend: friend)
        dismiss(animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
