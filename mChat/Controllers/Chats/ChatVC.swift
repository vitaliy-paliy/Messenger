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
    var imgFrame: CGRect?
    var imgBackground: UIView!
    var imageClickedView: UIImageView!
    
    var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), collectionViewLayout: UICollectionViewFlowLayout.init())
    var messageContainer = UIView()
    var clipImageButton = UIButton(type: .system)
    var sendButton = UIButton(type: .system)
    var messageTF = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "\(friendName!)"
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
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
        setupCollectionView()
        setupImageClipButton(topConst!)
        setupSendButton(topConst!)
        setupMessageTF(topConst!)
        setupProfileImage()
    }
    
    func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: "ChatCell")
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: messageContainer.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
        clipImageButton.tintColor = .black
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
        sendButton.tintColor = .black
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
        messageTF.attributedPlaceholder = NSAttributedString(string: "Write a message...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        messageTF.layer.cornerRadius = 8
        let textPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        messageTF.font = UIFont(name: "Helvetica Neue", size: 15)
        messageTF.leftView = textPadding
        messageTF.textColor = .black
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
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageToSend = originalImage
        }
        uploadImage(image: imageToSend)
        dismiss(animated: true, completion: nil)
    }
    
    func openImagePicker(type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
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
                    self.sendMediaMessage(url: url.absoluteString, image)
                }
            }
        }
        
    }
    
    func sendMediaMessage(url: String, _ image: UIImage){
        let values = ["sender": CurrentUser.uid!, "time": Date().timeIntervalSince1970, "recipient": friendId!, "mediaUrl": url] as [String: Any]
        let messageRef = Constants.db.reference().child("messages")
        let nodeRef = messageRef.childByAutoId()
        sendMessageHandler(ref: nodeRef, values: values)
    }
    
    @objc func sendButtonPressed(){
        guard messageTF.text!.count > 0 else { return }
        let ref = Constants.db.reference().child("messages")
        let nodeRef = ref.childByAutoId()
        let values = ["message": messageTF.text!, "sender": CurrentUser.uid!, "recipient": friendId!, "time": Date().timeIntervalSince1970] as [String : Any]
        sendMessageHandler(ref: nodeRef, values: values)
        self.messageTF.text = ""
    }
    
    func sendMessageHandler(ref: DatabaseReference, values: [String: Any]){
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let userMessages = Database.database().reference().child("messagesIds").child(CurrentUser.uid)
            let friendMessages = Database.database().reference().child("messagesIds").child(self.friendId)
            let messageId = ref.key
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
                        self.collectionView.reloadData()
                        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
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
            return false
        }else{
            return true
        }
    }
    
    func zoomImageHandler(image: UIImageView){
        imgFrame = image.superview?.convert(image.frame, to: nil)
        let photoView = UIImageView(frame: imgFrame!)
        photoView.isUserInteractionEnabled = true
        let slideUp = UISwipeGestureRecognizer(target: self, action: #selector(imageSlideUpDownHandler(tap:)))
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(imageSlideUpDownHandler(tap:)))
        slideUp.direction = .up
        slideDown.direction = .down
        photoView.addGestureRecognizer(slideUp)
        photoView.addGestureRecognizer(slideDown)
        photoView.backgroundColor = .red
        photoView.image = image.image
        let keyWindow = UIApplication.shared.windows[0]
        imgBackground = UIView(frame: keyWindow.frame)
        imgBackground.backgroundColor = .black
        imgBackground.alpha = 0
        keyWindow.addSubview(imgBackground)
        keyWindow.addSubview(photoView)
        let closeImageButton = UIButton(type: .system)
        imgBackground.addSubview(closeImageButton)
        imageClickedView = photoView
        closeImageButton.translatesAutoresizingMaskIntoConstraints = false
        closeImageButton.tintColor = .white
        closeImageButton.addTarget(self, action: #selector(closeImageButtonPressed), for: .touchUpInside)
        closeImageButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        
        var tAnchor = closeImageButton.topAnchor.constraint(equalTo: imgBackground.topAnchor, constant: 20)
        if imgBackground.safeAreaInsets.top > 25 {
            tAnchor = closeImageButton.topAnchor.constraint(equalTo: imgBackground.topAnchor, constant: 45)
        }
        let constraints = [
            closeImageButton.trailingAnchor.constraint(equalTo: imgBackground.trailingAnchor, constant: -16),
            tAnchor
        ]
        NSLayoutConstraint.activate(constraints)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.imgBackground.alpha = 1
            let height = self.imgFrame!.height / self.imgFrame!.width * keyWindow.frame.width
            photoView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            photoView.center = keyWindow.center
        }, completion: nil)
    }

    @objc func imageSlideUpDownHandler(tap: UISwipeGestureRecognizer){
        if let slideView = tap.view {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                slideView.frame = self.imgFrame!
                slideView.alpha = 0
                self.imgBackground.alpha = 0
            }) { (true) in
                slideView.removeFromSuperview()
            }
        }
    }
    
    @objc func closeImageButtonPressed(){
        let slideView = imageClickedView
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            slideView?.frame = self.imgFrame!
            slideView?.alpha = 0
            self.imgBackground.alpha = 0
        }) { (true) in
            slideView?.removeFromSuperview()
        }
    }
    
}

extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = messages[indexPath.row]
        if let message = message.message {
            height = calculateFrameInText(message: message).height + 10
        }else if message.mediaUrl != nil{
            height = 200
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let message = messages[indexPath.row]
        cell.chatVC = self
        cell.message.text = message.message
        if let message = message.message {
            cell.backgroundWidthAnchor.constant = calculateFrameInText(message: message).width + 32
        }else if message.mediaUrl != nil{
            cell.backgroundWidthAnchor.constant = 200
            cell.messageBackground.backgroundColor = .clear
        }
        if let url = message.mediaUrl{
            cell.mediaMessage.loadImage(url: url)
            cell.mediaMessage.isHidden = false
        }else{
            cell.mediaMessage.isHidden = true
        }
        
        if message.recipient == CurrentUser.uid{
            if message.mediaUrl == nil{
                cell.messageBackground.backgroundColor = .white
            }
            cell.message.textColor = .black
            cell.outcomingMessage.isActive = false
            cell.incomingMessage.isActive = true
        }else{
            if message.mediaUrl == nil{
                cell.messageBackground.backgroundColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
            }
            cell.message.textColor = .white
            cell.incomingMessage.isActive = false
            cell.outcomingMessage.isActive = true
        }
        return cell
    }
    
    
    
}
