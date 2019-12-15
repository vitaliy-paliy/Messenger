//
//  ChatVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class ChatVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var friendId: String!
    var friendName: String!
    var friendEmail: String!
    var friendProfileImage: String!
    var friendIsOnline: Bool!
    var friendLastLogin: NSNumber!
    var messages = [Messages]()
    var friendActivity = [FriendActivity]()
    var imageToSend: UIImage!
    var imgFrame: CGRect?
    var imgBackground: UIView!
    var imageClickedView: UIImageView!
    var startingImageFrame: UIImageView!
    
    var containerHeight: CGFloat!
    var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), collectionViewLayout: UICollectionViewFlowLayout.init())
    var messageContainer = UIView()
    var clipImageButton = UIButton(type: .system)
    var sendButton = UIButton(type: .system)
    var micButton = UIButton(type: .system)
    var messageTF = UITextView()
    var isTypingView = UIView()
    let typingAnimation = AnimationView()
    var timer = Timer()
    let calendar = Calendar(identifier: .gregorian)
    var fetchingMore = false
    var endReached = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatNavBar()
        getMessages()
        notificationCenterHandler()
        hideKeyboardOnTap(collectionView)
        observeIsUserTyping()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        var topConst: CGFloat!
        if view.safeAreaInsets.bottom > 0 {
            containerHeight = 70
            topConst = 12
        }else{
            containerHeight = 45
            topConst = 8
        }
        setupContainer(height: containerHeight!)
        setupCollectionView()
        setupImageClipButton(topConst)
        setupSendButton(topConst)
        setupMessageTF(topConst)
        setupMicrophone(topConst)
        setupProfileImage()
        setupUserTypingView()
    }
    
    func setupChatNavBar(){
        let loginDate = NSDate(timeIntervalSince1970: friendLastLogin.doubleValue)
        navigationController?.navigationBar.tintColor = .black
        if friendIsOnline {
            navigationItem.setNavTitles(navTitle: friendName, navSubtitle: "Online")
        }else{
            navigationItem.setNavTitles(navTitle: friendName, navSubtitle: calendar.calculateLastLogin(loginDate))
        }
        view.backgroundColor = .white
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
    
    var containerBottomAnchor = NSLayoutConstraint()
    func setupContainer(height: CGFloat){
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.backgroundColor = .white
        view.addSubview(messageContainer)
        let topLine = UIView()
        topLine.backgroundColor = UIColor(displayP3Red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        topLine.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.addSubview(topLine)
        containerBottomAnchor = messageContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let constraints = [
            messageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerBottomAnchor,
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
        sendButton.alpha = 0
        sendButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        sendButton.backgroundColor = .black
        sendButton.layer.cornerRadius = 15
        sendButton.layer.masksToBounds = true
        sendButton.tintColor = .white
        let constraints = [
            sendButton.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: topConst),
            sendButton.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -8),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
        ]
        NSLayoutConstraint.activate(constraints)
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    func setupMicrophone(_ topConst: CGFloat){
        messageContainer.addSubview(micButton)
        micButton.translatesAutoresizingMaskIntoConstraints = false
        micButton.setImage(UIImage(systemName: "mic"), for: .normal)
        micButton.tintColor = .black
        micButton.addTarget(self, action: #selector(startAudioRec), for: .touchUpInside)
        let constraints = [
            micButton.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: topConst),
            micButton.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -8),
            micButton.heightAnchor.constraint(equalToConstant: 30),
            micButton.widthAnchor.constraint(equalToConstant: 30),
        ]
        NSLayoutConstraint.activate(constraints)
        micButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    func setupMessageTF(_ topConst: CGFloat){
        messageContainer.addSubview(messageTF)
        messageTF.layer.cornerRadius = 12
        messageTF.font = UIFont(name: "Helvetica Neue", size: 16)
        messageTF.textColor = .black
        messageTF.isScrollEnabled = false
        messageTF.layer.borderWidth = 0.2
        messageTF.layer.borderColor = UIColor.systemGray.cgColor
        messageTF.layer.masksToBounds = true
        let messTFPlaceholder = UILabel()
        messTFPlaceholder.text = "Message"
        messTFPlaceholder.font = UIFont(name: "Helvetica Neue", size: 16)
        messTFPlaceholder.sizeToFit()
        messageTF.addSubview(messTFPlaceholder)
        messTFPlaceholder.frame.origin = CGPoint(x: 10, y: 6)
        messTFPlaceholder.textColor = .lightGray
        messageTF.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 10)
        messageTF.translatesAutoresizingMaskIntoConstraints = false
        messageTF.backgroundColor = UIColor(white: 0.95, alpha: 1)
        messageTF.adjustsFontForContentSizeCategory = true
        messageTF.delegate = self
        let constraints = [
            messageTF.leadingAnchor.constraint(equalTo: clipImageButton.trailingAnchor, constant: 8),
            messageTF.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            messageTF.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: topConst),
            messageTF.heightAnchor.constraint(equalToConstant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func clipImageButtonPressed() {
        openImagePicker(type: .photoLibrary)
    }
    
    @objc func startAudioRec(){
        print("TODO: Add Audio Rec")
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
        let values = ["sender": CurrentUser.uid!, "time": Date().timeIntervalSince1970, "recipient": friendId!, "mediaUrl": url, "width": image.size.width, "height": image.size.height] as [String: Any]
        let senderRef = Constants.db.reference().child("messages").child(CurrentUser.uid).childByAutoId()
        let recipientRef = Constants.db.reference().child("messages").child(friendId).childByAutoId()
        sendMessageHandler(senderRef: senderRef, recipientNodeRef: recipientRef, values: values)
    }
    
    @objc func sendButtonPressed(){
        let trimmedMessage = messageTF.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedMessage.count > 0 else { return }
        let senderRef = Constants.db.reference().child("messages").child(CurrentUser.uid).childByAutoId()
        let recipientRef = Constants.db.reference().child("messages").child(friendId).childByAutoId()
        let values = ["message": trimmedMessage, "sender": CurrentUser.uid!, "recipient": friendId!, "time": Date().timeIntervalSince1970] as [String : Any]
        sendMessageHandler(senderRef: senderRef, recipientNodeRef: recipientRef, values: values)
        messageTF.text = ""
        messageTF.subviews[2].isHidden = false
    }
    
    func sendMessageHandler(senderRef: DatabaseReference, recipientNodeRef: DatabaseReference,   values: [String: Any]){
        senderRef.updateChildValues(values)
        recipientNodeRef.updateChildValues(values)
        self.messageTF.text = ""
        disableIsTyping()
        messageTF.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = 32
                messageContainer.constraints.forEach { (const) in if const.firstAttribute == .height {
                    if sendingIsFinished(const: const){ return }}}}
        }
    }
    
    func getMessages(){
        let mRef = Constants.db.reference().child("messages").child(CurrentUser.uid)
        mRef.observe(.childAdded) { (data) in
            guard let values = data.value as? [String: Any] else {  return }
            let message = Messages()
            message.sender = values["sender"] as? String
            message.recipient = values["recipient"] as? String
            message.message = values["message"] as? String
            message.time = values["time"] as? NSNumber
            message.mediaUrl = values["mediaUrl"] as? String
            message.imageWidth = values["width"] as? NSNumber
            message.imageHeight = values["height"] as? NSNumber
            if message.determineUser() == self.friendId{
                self.messages.append(message)
                self.timer.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
                self.handleReload()
            }
        }
    }
    
    @objc func handleReload(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.scrollToTheBottom()
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
        view.endEditing(true)
        imgFrame = image.superview?.convert(image.frame, to: nil)
        let photoView = UIImageView(frame: imgFrame!)
        startingImageFrame = image
        startingImageFrame.isHidden = true
        photoView.isUserInteractionEnabled = true
        let slideUp = UISwipeGestureRecognizer(target: self, action: #selector(imageSlideUpDownHandler(tap:)))
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(imageSlideUpDownHandler(tap:)))
        slideUp.direction = .up
        slideDown.direction = .down
        photoView.addGestureRecognizer(slideUp)
        photoView.addGestureRecognizer(slideDown)
        photoView.image = image.image
        let keyWindow = UIApplication.shared.windows[0]
        imgBackground = UIView(frame: keyWindow.frame)
        imgBackground.backgroundColor = .black
        imgBackground.alpha = 0
        keyWindow.addSubview(imgBackground)
        keyWindow.addSubview(photoView)
        let closeImageButton = UIButton(type: .system)
        imageClickedView = photoView
        imgBackground.addSubview(closeImageButton)
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
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.imgBackground.alpha = 1
            let height = self.imgFrame!.height / self.imgFrame!.width * keyWindow.frame.width
            photoView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            photoView.center = keyWindow.center
        }) { (true) in
            
        }
    }
    
    @objc func imageSlideUpDownHandler(tap: UISwipeGestureRecognizer){
        if let slideView = tap.view as? UIImageView {
            handleZoomOutAnim(slideView: slideView)
        }
    }
    
    @objc func closeImageButtonPressed(){
        let slideView = imageClickedView
        handleZoomOutAnim(slideView: slideView!)
    }
    
    func handleZoomOutAnim(slideView: UIImageView){
        slideView.layer.cornerRadius = 16
        slideView.layer.masksToBounds = true
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            slideView.frame = self.imgFrame!
            self.imgBackground.alpha = 0
        }) { (true) in
            slideView.alpha = 0
            slideView.removeFromSuperview()
            self.startingImageFrame.isHidden = false
        }
    }
    
    func messageContainerHeightHandler(_ const: NSLayoutConstraint, _ estSize: CGSize){
        if sendingIsFinished(const: const) { return }
        let height = estSize.height
        if height > 150 { return }
        if messageTF.calculateLines() >= 2 {
            if containerHeight > 45 {
                const.constant = height + 35
            }else{ const.constant = height + 15 }
        }
    }
    
    func messageHeightHandler(_ constraint: NSLayoutConstraint, _ estSize: CGSize){
        if estSize.height > 150{
            messageTF.isScrollEnabled = true
            return
        }else if messageTF.calculateLines() < 2 {
            constraint.constant = 32
            animateMessageContainer()
            return
        }
        constraint.constant = estSize.height
        animateMessageContainer()
    }
    
    func sendingIsFinished(const: NSLayoutConstraint) -> Bool{
        if messageTF.text.count == 0 {
            messageTF.isScrollEnabled = false
            const.constant = containerHeight
            return true
        }else{
            return false
        }
    }
    
    func animateMessageContainer(){
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func notificationCenterHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func willResignActive(_ notification: Notification) {
        disableIsTyping()
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height, let duration = kDuration else { return }
        if containerHeight > 45 {
            containerBottomAnchor.constant = 13.2
        }
        containerBottomAnchor.constant += -height
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        scrollToTheBottom()
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let duration = kDuration else { return }
        containerBottomAnchor.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func animateActionButton(){
        var buttonToAnimate = UIButton()
        if messageTF.text.count >= 1 {
            micButton.alpha = 0
            if sendButton.alpha == 1 { return }
            sendButton.alpha = 1
            buttonToAnimate = sendButton
        }else if messageTF.text.count == 0{
            micButton.alpha = 1
            sendButton.alpha = 0
            buttonToAnimate = micButton
        }
        buttonToAnimate.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            buttonToAnimate.transform = .identity
        })
    }
    
    func isTypingHandler(){
        guard let friendId = friendId , let user = CurrentUser.uid else { return }
        let userRef = Database.database().reference().child("userActions").child(CurrentUser.uid).child(friendId)
        if messageTF.text.count >= 1 {
            userRef.setValue(["isTyping": true, "fromFriend": user])
        }else{
            userRef.setValue(["isTyping": false, "fromFriend": user])
        }
    }
    
    func observeIsUserTyping(){
        let db = Database.database().reference().child("userActions").child(friendId).child(CurrentUser.uid)
        db.observe(.value) { (snap) in
            guard let data = snap.value as? [String: Any] else { return }
            let activity = FriendActivity()
            activity.friendId = data["fromFriend"] as? String
            activity.isTyping = data["isTyping"] as? Bool
            self.friendActivity = [activity]
            guard self.friendActivity.count == 1 else { return }
            let friendActivity = self.friendActivity[0]
            if friendActivity.friendId == self.friendId && friendActivity.isTyping {
                self.animateTyping(const: 1, isHidden: false)
                self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 45, right: 0)
                self.scrollToTheBottom()
            }else{
                self.animateTyping(const: 0, isHidden: true)
                UIView.animate(withDuration: 0.5) {
                    self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
                }
            }
        }
        
    }
    
    func animateTyping(const: CGFloat, isHidden: Bool){
        UIView.animate(withDuration: 0.2, animations: {
            self.isTypingView.alpha = const
            self.typingAnimation.alpha = const
        }) { (true) in
            self.isTypingView.isHidden = isHidden
            self.typingAnimation.isHidden = isHidden
        }
    }
    
    func setupUserTypingView(){
        isTypingView.isHidden = true
        typingAnimation.isHidden = true
        isTypingView.backgroundColor = .white
        isTypingView.layer.cornerRadius = 16
        isTypingView.layer.masksToBounds = true
        view.addSubview(isTypingView)
        isTypingView.translatesAutoresizingMaskIntoConstraints = false
        isTypingView.addSubview(typingAnimation)
        typingAnimation.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            isTypingView.widthAnchor.constraint(equalToConstant: 80),
            isTypingView.heightAnchor.constraint(equalToConstant: 32),
            isTypingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            isTypingView.bottomAnchor.constraint(equalTo: messageContainer.topAnchor, constant: -8),
            typingAnimation.leadingAnchor.constraint(equalTo: isTypingView.leadingAnchor),
            typingAnimation.bottomAnchor.constraint(equalTo: isTypingView.bottomAnchor),
            typingAnimation.topAnchor.constraint(equalTo: isTypingView.topAnchor),
            typingAnimation.trailingAnchor.constraint(equalTo: isTypingView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        startAnimation()
    }
    
    func startAnimation(){
        typingAnimation.animationSpeed = 1.2
        typingAnimation.animation = Animation.named("chatTyping")
        typingAnimation.play()
        typingAnimation.loopMode = .loop
    }
    
    func scrollToTheBottom(){
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func disableIsTyping(){
        guard let friendId = friendId , let user = CurrentUser.uid else { return }
        let userRef = Database.database().reference().child("userActions").child(CurrentUser.uid).child(friendId)
        userRef.updateChildValues(["isTyping": false, "fromFriend": user])
    }
    
}

extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = messages[indexPath.row]
        if let message = message.message {
            height = calculateFrameInText(message: message).height + 10
        }else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue  {
            height = CGFloat(imageHeight / imageWidth * 200)
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
            cell.backgroundWidthAnchor.constant = 200
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

extension ChatVC: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        disableIsTyping()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        isTypingHandler()
        animateActionButton()
        if !messageTF.text.isEmpty {
            messageTF.subviews[2].isHidden = true
        }else{
            messageTF.subviews[2].isHidden = false
        }
        let size = CGSize(width: textView.frame.width, height: 150)
        let estSize = textView.sizeThatFits(size)
        messageTF.constraints.forEach { (constraint) in
            if constraint.firstAttribute != .height { return }
            messageHeightHandler(constraint, estSize)
            messageContainer.constraints.forEach { (const) in if const.firstAttribute == .height { messageContainerHeightHandler(const, estSize) }}
        }
    }
}
