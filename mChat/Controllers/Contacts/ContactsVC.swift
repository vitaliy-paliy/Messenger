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
    
    func setupFriendInfoMenuAnimation(_ friend: FriendInfo, _ cellFrame: CGRect, _ cell: UITableViewCell){
        blurView = setupInfoBlur()
        view.addSubview(blurView)
        infoMenu = UIView(frame: CGRect(x: 8, y: cellFrame.minY, width: cellFrame.width - 16, height: cellFrame.height))
        let infoImage = setupInfoImage(friend.profileImage, infoMenu)
        infoMenu.addSubview(infoImage)
        let infoName = setupInfoName(friend.name)
        infoMenu.addSubview(infoName)
        let infoEmail = setupInfoEmail(friend.email)
        infoMenu.addSubview(infoEmail)
        let exitButton = setupExitButton(cell, cellFrame)
        infoMenu.addSubview(exitButton)
        let sv = setupStackView()
        let constraints = [
            infoImage.widthAnchor.constraint(equalToConstant: 60),
            infoImage.heightAnchor.constraint(equalToConstant: 60), 
            exitButton.trailingAnchor.constraint(equalTo: infoMenu.trailingAnchor, constant: -10),
            exitButton.topAnchor.constraint(equalTo: infoMenu.topAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(constraints)
        infoMenu.backgroundColor = .white
        infoMenu.layer.cornerRadius = 8
        infoMenu.layer.shadowRadius = 10
        infoMenu.layer.shadowOpacity = 0.2
        infoMenu.alpha = 0
        view.addSubview(infoMenu)
        cell.alpha = 0
        self.infoMenu.alpha = 1
        self.blurView.alpha = 0.6
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.infoMenu.frame = CGRect(x: 40, y: self.view.center.y / 2, width: cellFrame.width - 80, height: cellFrame.height + 200)
            infoImage.layer.add(self.moveObjectToCenter(xValue: 10, yValue: 0, yConst: 80), forKey: "MoveImageToTheCenter")
            infoName.layer.add(self.moveObjectToCenter(xValue: 60, yValue: 80, yConst: 130), forKey: "MoveNameToTheCenter")
            infoEmail.layer.add(self.moveObjectToCenter(xValue: 60, yValue: 130, yConst: 160), forKey: "MoveEmailToTheCenter")
        }) { (true) in
            exitButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            sv.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                exitButton.transform = .identity
                sv.transform = .identity
                exitButton.alpha = 1
                sv.alpha = 1
            })
        }
    }

    func setupStackView() -> UIStackView{
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        let view1 = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view1.tintColor = .black
        view1.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        view1.layer.cornerRadius = view1.frame.size.width / 2
        view1.layer.shadowOpacity = 0.3
        view1.layer.shadowRadius = 5
        view1.backgroundColor = .white
        sv.addArrangedSubview(view1)
        let view2 = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view2.tintColor = .black
        view2.setImage(UIImage(systemName: "map"), for: .normal)
        view2.layer.cornerRadius = view1.frame.size.width / 2
        view2.layer.shadowOpacity = 0.3
        view2.layer.shadowRadius = 5
        view2.backgroundColor = .white
        sv.addArrangedSubview(view2)
        let view3 = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view3.tintColor = .black
        view3.setImage(UIImage(systemName: "person.badge.minus"), for: .normal)
        view3.layer.cornerRadius = view1.frame.size.width / 2
        view3.layer.shadowOpacity = 0.3
        view3.layer.shadowRadius = 5
        view3.backgroundColor = .white
        sv.addArrangedSubview(view3)
        sv.translatesAutoresizingMaskIntoConstraints = false
        infoMenu.addSubview(sv)
        let constraints = [
            sv.bottomAnchor.constraint(equalTo: infoMenu.bottomAnchor, constant: -25),
            sv.leadingAnchor.constraint(equalTo: infoMenu.leadingAnchor, constant: 80),
            sv.trailingAnchor.constraint(equalTo: infoMenu.trailingAnchor, constant: -80),
            sv.heightAnchor.constraint(equalToConstant: 40),
            view1.widthAnchor.constraint(equalToConstant: 40),
            view2.widthAnchor.constraint(equalToConstant: 40),
            view3.widthAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(constraints)
        sv.alpha = 0
        return sv
    }
    
    func moveObjectToCenter(xValue: CGFloat, yValue: CGFloat, yConst: CGFloat) -> CAKeyframeAnimation{
        let movingImageAnimation = CAKeyframeAnimation(keyPath: "position")
        let viewCenterConst = self.infoMenu.center.x - 40
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xValue, y: yValue))
        path.addQuadCurve(to: CGPoint(x: viewCenterConst, y: yConst), controlPoint: CGPoint(x: self.infoMenu.frame.width * 1/3, y: 120))
        movingImageAnimation.path = path.cgPath
        movingImageAnimation.duration = 0.25
        movingImageAnimation.fillMode = .forwards
        movingImageAnimation.isRemovedOnCompletion = false
        return movingImageAnimation
    }
    
    func setupExitButton(_ cell: UITableViewCell, _ cellFrame: CGRect) -> UIButton{
        let exitButton = contactsAnimationButton(type: .system)
        exitButton.cell = cell
        exitButton.cellFrame = cellFrame
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        exitButton.tintColor = .black
        exitButton.addTarget(self, action: #selector(exitMenuHandler(_:)), for: .touchUpInside)
        exitButton.alpha = 0
        return exitButton
    }
    
    func setupInfoBlur() -> UIVisualEffectView{
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        return blurView
    }
    
    func setupInfoImage(_ friendImage: String, _ animationView: UIView) -> UIImageView{
        let infoImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        infoImage.translatesAutoresizingMaskIntoConstraints = false
        infoImage.loadImage(url: friendImage)
        infoImage.layer.cornerRadius = infoImage.frame.width / 2
        infoImage.layer.masksToBounds = true
        infoImage.contentMode = .scaleAspectFill
        return infoImage
    }
    
    func setupInfoName(_ friendName: String) -> UILabel{
        let infoName = UILabel()
        infoName.translatesAutoresizingMaskIntoConstraints = false
        infoName.textAlignment = .center
        infoName.text = friendName
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
        infoEmail.alpha = 1
        return infoEmail
    }
    
    @objc func exitMenuHandler(_ button: contactsAnimationButton){
        infoMenu.transform = CGAffineTransform(translationX: -3, y: 2)
        guard let cellFrame = button.cellFrame else { return }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.blurView.alpha = 0
            self.infoMenu.subviews.forEach { $0.isHidden = true }
            self.infoMenu.frame = CGRect(x: 8, y: cellFrame.minY, width: cellFrame.width - 16, height: cellFrame.height)
        }) { (true) in
            button.cell?.alpha = 1
            self.infoMenu.alpha = 0
        }
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
        if let cellFrame = tableView.cellForRow(at: indexPath)?.frame, let cell = tableView.cellForRow(at: indexPath){
            let convertedFrame = tableView.convert(cellFrame, to: tableView.superview)
            setupFriendInfoMenuAnimation(friend, convertedFrame, cell)
        }
    }
    
}

