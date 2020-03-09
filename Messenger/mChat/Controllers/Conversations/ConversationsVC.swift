//
//  ConversationsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Lottie

class ConversationsVC: UIViewController {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // ConversationVC is responsible for showing recent messages from user's friends and their actions. (If user and his/her friend haven't had a conversation, then friend's cell in tableView won't be visible. )
    
    let convNetworking = ConversationsNetworking()
    var messages = [Messages]()
    let tableView = UITableView()
    let calendar = Calendar(identifier: .gregorian)
    var newConversationButton = UIBarButtonItem()
    var tabBarBadge: UITabBarItem!
    let blankLoadingView = AnimationView(animation: Animation.named("blankLoadingAnim"))
    var emptyListView: EmptyListView!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        view.backgroundColor = .white
        if let tabItems = tabBarController?.tabBar.items {
            tabBarBadge = tabItems[1]
        }
        loadConversations()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUI(){
        setupNewConversationButton()
        setupTableView()
        emptyListView = EmptyListView(nil, self, false)
        setupBlankView(blankLoadingView)
        Friends.convVC = self
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
        tableView.register(ConversationsCell.self, forCellReuseIdentifier: "ConversationsCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNewConversationButton() {
        newConversationButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(newConversationTapped))
        newConversationButton.tintColor = .black
        navigationItem.rightBarButtonItem = newConversationButton
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func newConversationTapped() {
        let controller = NewConversationVC()
        controller.conversationDelegate = self
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: LOAD CONVERSATIONS METHOD
    
    private func loadConversations() {
        convNetworking.convVC = self
        convNetworking.observeFriendsList()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func loadMessagesHandler(_ newMessages: [Messages]?) {
        blankLoadingView.isHidden = true
        if let newMessages = newMessages {
            handleReload(newMessages)
        }
        observeMessageActions()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: HANDLE RELOAD
    
    private func handleReload(_ newMessages: [Messages]) {
        messages = newMessages
        if messages.count != 0 {
            emptyListView.isHidden = true
            emptyListView.emptyButton.isHidden = true
        }
        messages.sort { (message1, message2) -> Bool in
            return message1.time.intValue > message2.time.intValue
        }
        tableView.reloadData()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: MESSAGE ACTIONS.
    
    func observeMessageActions() {
        convNetworking.observeDeletedMessages()
        convNetworking.observeNewMessages { (newMessages) in
            self.handleReload(newMessages)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func nextControllerHandler(usr: FriendInfo) {
        let controller = ChatVC()
        controller.modalPresentationStyle = .fullScreen
        controller.friend = usr
        convNetworking.removeConvObservers()
        show(controller, sender: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func observeIsUserTypingHandler(_ recent: Messages, _ cell: ConversationsCell){
        convNetworking.observeIsUserTyping(recent.determineUser()) { (isTyping, friendId) in
            if isTyping && cell.message?.determineUser() == friendId {
                cell.recentMessage.isHidden = true
                cell.timeLabel.isHidden = true
                cell.isTypingView.isHidden = false
                cell.checkmark.isHidden = true
            }else{
                self.setupNoTypingCell(cell)
                if cell.message?.sender == CurrentUser.uid{
                    cell.checkmark.isHidden = false
                }
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func observeIsUserSeenMessage(_ recent: Messages, _ cell: ConversationsCell) {
        guard let id = cell.message?.determineUser() else { return }
        convNetworking.observeUserSeenMessage(id) { (num) in
            if num == 0 {
                cell.checkmark.image = UIImage(named: "doubleCheckmark_icon")
            }else{
                cell.checkmark.image = UIImage(named: "checkmark_icon")
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
