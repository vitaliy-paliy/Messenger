//
//  ContactsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ContactsVC: UIViewController {
    
    var friendsList: [FriendInfo] = []
    var backgroundImage = UIImageView()
    var timer = Timer()
    var tableView = UITableView()
    var addButton = UIBarButtonItem()
    let animationView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Contacts"
        view.backgroundColor = .white
        setupTableView()
        setupaddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.isHidden = true
        loadFriends()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        friendsList = []
    }

    func setupTableView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ContactsCell.self, forCellReuseIdentifier: "ContactsCell")
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
    
    func setupaddButton(){
        let buttonView = UIButton(type: .system)
        buttonView.backgroundColor = UIColor(white: 0.932, alpha: 1)
//        TODO: Shadow Navigation bug fix
//        buttonView.layer.shadowRadius = 10
//        buttonView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        buttonView.layer.shadowOpacity = 0.3
        buttonView.layer.cornerRadius = 15
        buttonView.layer.masksToBounds = true
        buttonView.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        buttonView.setTitle("Add Friend", for: .normal)
        buttonView.setTitleColor(.black, for: .normal)
        buttonView.tintColor = .black
        buttonView.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
        buttonView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        buttonView.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton = UIBarButtonItem(customView: buttonView)
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonPressed(){
        let controller = UsersListVC()
        controller.modalPresentationStyle = .fullScreen
        self.show(controller, sender: nil)
    }
   
}

extension ContactsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell") as! ContactsCell
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
        controller.friendEmail = friend.email
        controller.friendProfileImage = friend.profileImage
        controller.friendName = friend.name
        controller.friendId = friend.id
        show(controller, sender: nil)
        friendsList = []
    }
    
}
