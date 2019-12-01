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
    var infoMenu = UIView()
    var blurView = UIVisualEffectView()
    
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
    
    func setupFriendInfoMenuAnimation(_ friend: FriendInfo){
        blurView = setupInfoBlur()
        view.addSubview(blurView)
        let menuWidth = view.frame.maxX / 1.2
        let menuHeight = view.frame.maxY / 2
        infoMenu = setupInfoMenu(menuWidth, menuHeight)
        let infoImage = setupInfoImage(friend.profileImage, menuWidth)
        infoMenu.addSubview(infoImage)
        let infoName = setupInfoName(friend.name)
        infoMenu.addSubview(infoName)
        let infoEmail = setupInfoEmail(friend.email)
        infoMenu.addSubview(infoEmail)
        let exitButton = setupExitButton()
        infoMenu.addSubview(exitButton)
        let constraints = [
            infoImage.topAnchor.constraint(equalTo: infoMenu.topAnchor, constant: 15),
            infoImage.centerXAnchor.constraint(equalTo: infoMenu.centerXAnchor),
            infoImage.widthAnchor.constraint(equalToConstant: menuWidth / 3),
            infoImage.heightAnchor.constraint(equalToConstant: menuWidth / 3),
            infoName.topAnchor.constraint(equalTo: infoImage.bottomAnchor, constant: 10),
            infoName.centerXAnchor.constraint(equalTo: infoMenu.centerXAnchor),
            infoName.leadingAnchor.constraint(equalTo: infoMenu.leadingAnchor),
            infoName.trailingAnchor.constraint(equalTo: infoMenu.trailingAnchor),
            infoName.heightAnchor.constraint(equalToConstant: 25),
            infoEmail.topAnchor.constraint(equalTo: infoName.bottomAnchor),
            infoEmail.centerXAnchor.constraint(equalTo: infoMenu.centerXAnchor),
            infoEmail.leadingAnchor.constraint(equalTo: infoMenu.leadingAnchor),
            infoEmail.trailingAnchor.constraint(equalTo: infoMenu.trailingAnchor),
            infoEmail.heightAnchor.constraint(equalToConstant: 30),
            exitButton.trailingAnchor.constraint(equalTo: infoMenu.trailingAnchor, constant: -10),
            exitButton.topAnchor.constraint(equalTo: infoMenu.topAnchor, constant: 10),
        ]
        NSLayoutConstraint.activate(constraints)
        view.addSubview(infoMenu)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.blurView.alpha = 0.5
        }) { (true) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.infoMenu.transform = .identity
                self.infoMenu.center.x = self.view.center.x
                self.infoMenu.center.y = self.view.center.y - (self.view.frame.maxY / 8)
            })
        }
    }
    
    func setupExitButton() -> UIButton{
        let exitButton = UIButton(type: .system)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        exitButton.tintColor = .black
        exitButton.addTarget(self, action: #selector(exitMenuHandler), for: .touchUpInside)
        return exitButton
    }
    
    func setupInfoBlur() -> UIVisualEffectView{
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        return blurView
    }
    
    func setupInfoMenu(_ mWidth: CGFloat, _ mHeight: CGFloat) -> UIView{
        let infoMenu = UIView(frame: CGRect(x: view.center.x, y: 2000, width: mWidth, height: mHeight))
        infoMenu.transform = CGAffineTransform(rotationAngle: 3.5)
        infoMenu.backgroundColor = .white
        infoMenu.layer.shadowColor = UIColor.black.cgColor
        infoMenu.layer.shadowRadius = 10
        infoMenu.layer.shadowOpacity = 0.5
        infoMenu.layer.cornerRadius = 16
        return infoMenu
    }
    
    func setupInfoImage(_ friendImage: String, _ mWidth: CGFloat) -> UIImageView{
        let infoImage = UIImageView()
        infoImage.translatesAutoresizingMaskIntoConstraints = false
        infoImage.loadImage(url: friendImage)
        infoImage.layer.cornerRadius = (mWidth / 3) / 2
        infoImage.layer.masksToBounds = true
        infoImage.contentMode = .scaleAspectFill
        return infoImage
    }
    
    func setupInfoName(_ friendName: String) -> UILabel{
        let infoName = UILabel()
        infoName.translatesAutoresizingMaskIntoConstraints = false
        infoName.text = friendName
        infoName.textAlignment = .center
        infoName.textColor = .black
        infoName.font = UIFont(name: "Helvetica Neue", size: 24)
        return infoName
    }
    
    func setupInfoEmail(_ friendEmail: String) -> UILabel{
        let infoEmail = UILabel()
        infoEmail.translatesAutoresizingMaskIntoConstraints = false
        infoEmail.text = friendEmail
        infoEmail.textAlignment = .center
        infoEmail.textColor = .lightGray
        infoEmail.font = UIFont(name: "Helvetica Neue", size: 16)
        return infoEmail
    }
 
    @objc func exitMenuHandler(){
        infoMenu.transform = CGAffineTransform(translationX: -3, y: 2)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.infoMenu.transform = .identity
            self.blurView.alpha = 0
            self.infoMenu.alpha = 0
        })
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
        setupFriendInfoMenuAnimation(friend)
        //        let controller = ChatVC()
        //        controller.friendEmail = friend.email
        //        controller.friendProfileImage = friend.profileImage
        //        controller.friendName = friend.name
        //        controller.friendId = friend.id
        //        show(controller, sender: nil)
        //        friendsList = []
    }
    
}
