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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
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
        Constants.db.reference().child("friendsList").child(CurrentUser.uid).observe(.value) { (snap) in
            self.friendsList = []
            self.tableView.reloadData()
            guard let friends = snap.value as? [String: Any] else { return }
            for dict in friends.keys {
                self.setupFriendsList(dict)
            }
        }
    }
    
    func setupFriendsList(_ key: String){
        Constants.db.reference().child("users").child(key).observeSingleEvent(of: .value) { (data) in
            guard let values = data.value as? [String: Any] else { return }
            var friend = FriendInfo()
            friend.id = key
            friend.email = values["email"] as? String
            friend.profileImage = values["profileImage"] as? String
            friend.name = values["name"] as? String
            friend.isOnline = values["isOnline"] as? Bool
            friend.lastLogin = values["lastLogin"] as? NSNumber
            self.friendsList.append(friend)
            self.friendsList.sort { (friend1, friend2) -> Bool in
                return friend1.name < friend2.name
            }
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
        }
    }
    
    @objc func handleReload(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupaddButton(){
        var addButton = UIBarButtonItem()
        let buttonView = UIButton(type: .system)
        buttonView.setImage(UIImage(systemName: "plus"), for: .normal)
        buttonView.tintColor = .black
        buttonView.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton = UIBarButtonItem(customView: buttonView)
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonPressed(){
        let controller = UsersListVC()
        controller.modalPresentationStyle = .fullScreen
        self.show(controller, sender: nil)
    }
    
    func setupFriendInfoMenuAnimation(_ friend: FriendInfo, _ cellFrame: CGRect, _ cell: ContactsCell){
        self.tableView.isUserInteractionEnabled = false
        blurView = setupInfoBlur()
        infoMenu = UIView(frame: CGRect(x: 8, y: cellFrame.minY, width: cellFrame.width - 16, height: cellFrame.height))
        let infoImage = setupInfoImage(friend.profileImage, infoMenu)
        infoMenu.addSubview(infoImage)
        let infoName = setupInfoName(friend.name)
        infoMenu.addSubview(infoName)
        let infoEmail = setupInfoEmail(friend.email)
        infoMenu.addSubview(infoEmail)
        let exitButton = setupExitButton(cell, cellFrame)
        infoMenu.addSubview(exitButton)
        let sv = setupStackView(friend)
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
        infoMenu.alpha = 1
        self.blurView.alpha = 0.6
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.blurView.layer.add(self.blurEffectAnim(), forKey: "Animation")
            self.infoMenu.frame = CGRect(x: 40, y: self.view.center.y / 2, width: cellFrame.width - 80, height: cellFrame.height + 200)
            infoImage.layer.add(self.moveObjectToCenter(xValue: 10, yValue: 0, yConst: 80), forKey: "MoveImageToTheCenter")
            infoName.layer.add(self.moveObjectToCenter(xValue: 60, yValue: 80, yConst: 130), forKey: "MoveNameToTheCenter")
            infoEmail.layer.add(self.moveObjectToCenter(xValue: 60, yValue: 130, yConst: 160), forKey: "MoveEmailToTheCenter")
        }) { (true) in
            exitButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            sv.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                exitButton.transform = .identity
                sv.transform = .identity
                for f in 0..<sv.arrangedSubviews.count {
                    sv.arrangedSubviews[f].transform = .identity
                }
                exitButton.alpha = 1
                sv.alpha = 1
            })
        }
    }
    
    func setupExitButton(_ cell: ContactsCell, _ cellFrame: CGRect) -> UIButton{
        let exitButton = ContactsAnimationButton(type: .system)
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
        blurView.frame = CGRect(x: view.center.x, y: view.center.y, width: 40, height: 40)
        blurView.layer.cornerRadius = blurView.frame.width / 2
        blurView.layer.masksToBounds = true
        view.addSubview(blurView)
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
    
    func setupStackView(_ friend: FriendInfo) -> UIStackView{
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        let view1 = setupInfoMenuButtons(friend,"square.and.pencil", sv)
        let view2 = setupInfoMenuButtons(friend,"map", sv)
        let view3 = setupInfoMenuButtons(friend,"person.badge.minus", sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        infoMenu.addSubview(sv)
        let constraints = [
            sv.bottomAnchor.constraint(equalTo: infoMenu.bottomAnchor, constant: -25),
            sv.leadingAnchor.constraint(equalTo: infoMenu.leadingAnchor, constant: 70),
            sv.trailingAnchor.constraint(equalTo: infoMenu.trailingAnchor, constant: -70),
            sv.heightAnchor.constraint(equalToConstant: 40),
            view1.widthAnchor.constraint(equalToConstant: 40),
            view2.widthAnchor.constraint(equalToConstant: 40),
            view3.widthAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(constraints)
        sv.alpha = 0
        return sv
    }
    
    @objc func exitMenuHandler(_ button: ContactsAnimationButton){
        infoMenu.transform = CGAffineTransform(translationX: -3, y: 2)
        let infoImage = self.infoMenu.subviews[0]
        let infoName = self.infoMenu.subviews[1] as? UILabel
        let infoEmail = self.infoMenu.subviews[2] as? UILabel
        guard let cellFrame = button.cellFrame else { return }
        infoName?.font = UIFont(name: "Menlo Regular", size: UIFont.systemFontSize)
        infoEmail?.font = UIFont(name: "Menlo Regular", size: UIFont.systemFontSize)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.infoMenu.subviews[3].isHidden = true
            self.infoMenu.subviews[4].isHidden = true
            let menuWidth = self.infoMenu.frame.width
            let menuHeight = self.infoMenu.frame.height
            infoName?.layer.add(self.exitObjectAnimation(
                startPoint: CGPoint(x: menuWidth/2,
                                    y: menuHeight/2),
                finishPoint: CGPoint(x: 250, y: 25)),
                                forKey: "Animate Name")
            infoName?.layer.add(self.fadeOutAnimation(1, 0, durTime: 0.1), forKey: "nameFadeOut")
            infoImage.layer.add(self.exitObjectAnimation(
                startPoint: CGPoint(x: menuWidth/2, y: menuHeight/3),
                finishPoint: CGPoint(x: 45, y: 45)),
                                forKey: "Animate Image")
            infoEmail?.layer.add(self.exitObjectAnimation(
                startPoint: CGPoint(x: menuWidth/2, y: menuHeight/3),
                finishPoint: CGPoint(x: 250, y: 45)),
                                 forKey: "Animate Email")
            infoEmail?.layer.add(self.fadeOutAnimation(1, 0, durTime: 0.1), forKey: "emailFadeOut")
            self.infoMenu.frame = CGRect(x: 8, y: cellFrame.minY, width: cellFrame.width - 16, height: cellFrame.height)
        }) { (true) in
            self.finalMenuAnimation(button.cell)
        }
    }
    
    func finalMenuAnimation(_ cell: ContactsCell?){
        UIView.animate(withDuration: 0.1, animations: {
            cell?.alpha = 1
            self.blurView.alpha = 0
            self.infoMenu.layer.add(self.fadeOutAnimation(1, 0, durTime: 0.1), forKey: "infoMenuFadeOutAnim")
        }) { (true) in
            
            self.infoMenu.alpha = 0
            self.tableView.isUserInteractionEnabled = true
            
        }
    }
    
    func fadeOutAnimation(_ fromValue: CGFloat, _ toValue: CGFloat, durTime: Double) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = durTime
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    func exitObjectAnimation(startPoint: CGPoint, finishPoint: CGPoint) -> CAKeyframeAnimation{
        let positionAnim = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addQuadCurve(to: finishPoint, controlPoint: CGPoint(x: 30, y: 100))
        positionAnim.path = path.cgPath
        positionAnim.fillMode = .forwards
        positionAnim.isRemovedOnCompletion = false
        positionAnim.duration = 0.2
        return positionAnim
    }
    
    func blurEffectAnim() -> CABasicAnimation{
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.fromValue = 1
        anim.toValue = view.frame.width / 8
        anim.duration = 0.6
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        return anim
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
    
    func setupInfoMenuButtons(_ friend: FriendInfo, _ imageName: String, _ sv: UIStackView) -> ContactsAnimationButton{
        let button = ContactsAnimationButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.friendInfo = friend
        button.tintColor = .black
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.layer.cornerRadius = button.frame.size.width / 2
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.backgroundColor = .white
        button.transform = CGAffineTransform(rotationAngle: 2.5)
        sv.addArrangedSubview(button)
        if imageName == "square.and.pencil" {
            button.addTarget(self, action: #selector(writeMessage(_:)), for: .touchUpInside)
        }else if imageName == "map"{
            button.addTarget(self, action: #selector(openMap(_:)), for: .touchUpInside)
        }else{
            button.addTarget(self, action: #selector(removeFriend(_:)), for: .touchUpInside)
        }
        return button
    }
    
    @objc func writeMessage(_ button: ContactsAnimationButton){
        guard let bInfo = button.friendInfo else { return }
        let controller = ChatVC()
        controller.modalPresentationStyle = .fullScreen
        controller.friend = bInfo
//        controller.friendId = bInfo.id
//        controller.friendProfileImage = bInfo.profileImage
//        controller.friendName = bInfo.name
//        controller.friendEmail = bInfo.email
//        controller.friendIsOnline = bInfo.isOnline
//        controller.friendLastLogin = bInfo.lastLogin
        show(controller, sender: nil)
    }
    
    @objc func openMap(_ button: ContactsAnimationButton){
        print("TODO: Map")
    }
    
    @objc func removeFriend(_ button: ContactsAnimationButton){
        guard let bInfo = button.friendInfo else { return }
        let controller = AddFriendVC()
        controller.modalPresentationStyle = .fullScreen
        controller.friendId = bInfo.id
        controller.friendProfileImage = bInfo.profileImage
        controller.friendName = bInfo.name
        controller.friendEmail = bInfo.email
        show(controller, sender: nil)
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
        if friend.isOnline {
            cell.isOnlineView.isHidden = false
        }else {
            cell.isOnlineView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friendsList[indexPath.row]
        if let cellFrame = tableView.cellForRow(at: indexPath)?.frame, let cell = tableView.cellForRow(at: indexPath){
            let convertedFrame = tableView.convert(cellFrame, to: tableView.superview)
            setupFriendInfoMenuAnimation(friend, convertedFrame, cell as! ContactsCell)
        }
    }
    
}

