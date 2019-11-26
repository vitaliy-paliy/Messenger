//
//  ChatVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var friendId: String!
    var friendName: String!
    var friendEmail: String!
    var friendProfileImage: String!
    var messages = [Messages]()
    var imageToSend: UIImage!
    
    var tableView = UITableView()
    var messageContainer = UIView()
    var clipImageButton = UIButton(type: .system)
    var sendButton = UIButton(type: .system)
    var messageTF = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(friendName!)"
        view.backgroundColor = .white
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
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        var containerHeight: CGFloat?
        var topConst: CGFloat?
        if view.safeAreaInsets.bottom > 0 {
            containerHeight = 70
            topConst = 12
        }else{
            containerHeight = 45
            topConst = 8
        }
        setupContainer(height: containerHeight!)
        setupTableView()
        setupImageClipButton(topConst!)
        setupSendButton(topConst!)
        setupMessageTF(topConst!)
        setupProfileImage()
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageContainer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupProfileImage(){
        let friendImageButton = UIButton(type: .system)
        let image = UIImageView()
        image.loadImage(url: friendProfileImage)
        friendImageButton.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        let constraints = [
            image.leadingAnchor.constraint(equalTo: friendImageButton.leadingAnchor),
            image.centerYAnchor.constraint(equalTo: friendImageButton.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 32),
            image.widthAnchor.constraint(equalToConstant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
        friendImageButton.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: friendImageButton)
    }
    
    func setupContainer(height: CGFloat){
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
            messageContainer.heightAnchor.constraint(equalToConstant: height),
            topLine.leftAnchor.constraint(equalTo: view.leftAnchor),
            topLine.rightAnchor.constraint(equalTo: view.rightAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 0.5)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupImageClipButton(_ topConst: CGFloat){
        clipImageButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
        messageContainer.addSubview(clipImageButton)
        clipImageButton.contentMode = .scaleAspectFill
        clipImageButton.addTarget(self, action: #selector(clipImageButtonPressed), for: .touchUpInside)
        clipImageButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            clipImageButton.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 8),
            clipImageButton.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: topConst),
            clipImageButton.widthAnchor.constraint(equalToConstant: 30),
            clipImageButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupSendButton(_ topConst: CGFloat){
        messageContainer.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        let constraints = [
            sendButton.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: topConst),
            sendButton.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -8),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
        ]
        NSLayoutConstraint.activate(constraints)
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    func setupMessageTF(_ topConst: CGFloat){
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
        messageTF.backgroundColor = UIColor(white: 0.95, alpha: 1)
        messageTF.delegate = self
        let constraints = [
            messageTF.leadingAnchor.constraint(equalTo: clipImageButton.trailingAnchor, constant: 8),
            messageTF.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 0),
            messageTF.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: topConst),
            messageTF.heightAnchor.constraint(equalToConstant: 30),
            messageTF.centerYAnchor.constraint(equalTo: messageTF.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func clipImageButtonPressed() {
        openImagePicker(type: .photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageToSend = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageToSend = originalImage
        }
        uploadImage(image: imageToSend)
        dismiss(animated: true, completion: nil)
    }
    
    func openImagePicker(type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage){
        let mediaName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("message-img").child(mediaName)
        if let jpegName = self.imageToSend.jpegData(compressionQuality: 0.1) {
            storageRef.putData(jpegName, metadata: nil) { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    guard let url = url else { return }
                    self.sendMediaMessage(url: url.absoluteString)
                }
            }
        }
        
    }
    
    func sendMediaMessage(url: String){
        guard let sender = CurrentUser.uid else { return }
        guard let recipient = friendId else { return }
        let values = ["mediaUrl": url, "sender": sender, "time": Date().timeIntervalSince1970, "recipient": recipient] as [String: Any]
        let messageRef = Constants.db.reference().child("messages")
        let nodeRef = messageRef.childByAutoId()
        nodeRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let userMessages = Database.database().reference().child("messagesIds").child(sender)
            let friendMessages = Database.database().reference().child("messagesIds").child(recipient)
            let messageId = nodeRef.key
            let userValues = [messageId: 1]
            userMessages.updateChildValues(userValues)
            friendMessages.updateChildValues(userValues)
        }
    }
    
    @objc func sendButtonPressed(){
        guard messageTF.text!.count > 1 else { return }
        let ref = Constants.db.reference().child("messages")
        let nodeRef = ref.childByAutoId()
        guard let friend = friendId else { return }
        guard let sender = CurrentUser.uid else { return }
        let values = ["message": messageTF.text!, "sender": sender, "recipient": friend, "time": Date().timeIntervalSince1970] as [String : Any]
        nodeRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let userMessages = Database.database().reference().child("messagesIds").child(sender)
            let friendMessages = Database.database().reference().child("messagesIds").child(friend)
            let messageId = nodeRef.key
            let userValues = [messageId: 1]
            userMessages.updateChildValues(userValues)
            friendMessages.updateChildValues(userValues)
        }
        self.messageTF.text = ""
    }
    
    func getMessages(){
        let messagesIds = Database.database().reference().child("messagesIds").child(CurrentUser.uid)
        messagesIds.observe(.childAdded) { (snap) in
            Constants.db.reference().child("messages").child(snap.key).observeSingleEvent(of: .value) { (data) in
                guard let values = data.value as? [String: Any] else {  return }
                let message = Messages()
                message.sender = values["sender"] as? String
                message.recipient = values["recipient"] as? String
                message.message = values["message"] as? String
                message.time = values["time"] as? NSNumber
                message.mediaUrl = values["mediaUrl"] as? String
                if message.determineUser() == self.friendId{
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: (self.messages.count - 1), section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                }
            }
        }
    }
    
    @objc func profileImageTapped(){
        print("Hi")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonPressed()
        return true
    }
    
    func isIncomingHandler(sender: String) -> Bool{
        if sender == CurrentUser.uid {
            return true
        }else{
            return false
        }
    }
    
}

extension ChatVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        let message = messages[indexPath.row]
        if let image = message.mediaUrl {
            cell.isMediaMessage = true
            cell.isIncoming = isIncomingHandler(sender: message.sender)
            cell.mediaMessage.loadImage(url: image)
            return cell
        }else{
            cell.isMediaMessage = false
            cell.isIncoming = isIncomingHandler(sender: message.sender)
            cell.message.text = message.message
            return cell
        }
    }
    
}
