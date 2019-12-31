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

protocol ForwardToFriend {
    func forwardToSelectedFriend(friend: FriendInfo, for name: String)
}

class ChatVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    var friend: FriendInfo!
    var messages = [Messages]()
    let chatNetworking = ChatNetworking()
    var userResponse = UserResponse()
    var imageGalleryView = ImageGalleryView()
    
    // TODO: ChatView Outlets
    var containerHeight: CGFloat!
    var containerBottomAnchor = NSLayoutConstraint()
    var containterHAnchor = NSLayoutConstraint()
    var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), collectionViewLayout: UICollectionViewFlowLayout.init())
    var messageContainer = UIView()
    var clipImageButton = UIButton(type: .system)
    var sendButton = UIButton(type: .system)
    var micButton = UIButton(type: .system)
    var messageTV = UITextView()
    var refreshIndicator = RefreshIndicator(style: .medium)
    var toolsBlurView = ToolsBlurView()
    var toolsScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChat()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        setuplongPress()
        notificationCenterHandler()
        hideKeyboardOnTap(collectionView)
    }
    
    func setupChat(){
        chatNetworking.friend = friend
        setupChatNavBar()
        fetchMessages()
        setupProfileImage()
        observeMessageActions()
        observeFriendTyping()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        var topConst: CGFloat!
        if view.safeAreaInsets.bottom > 0 {
            containerHeight = 70
            topConst = 28
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
        setupLoadMoreIndicator(topConst)
    }
    
    func setupChatNavBar(){
        let loginDate = NSDate(timeIntervalSince1970: friend.lastLogin.doubleValue)
        navigationController?.navigationBar.tintColor = .black
        if friend.isOnline {
            navigationItem.setNavTitles(navTitle: friend.name, navSubtitle: "Online")
        }else{
            navigationItem.setNavTitles(navTitle: friend.name, navSubtitle: calendar.calculateLastLogin(loginDate))
        }
    }
    
    func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
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
        let friendImageIcon = UIImageView()
        friendImageIcon.loadImage(url: friend.profileImage)
        friendImageButton.addSubview(friendImageIcon)
        friendImageIcon.translatesAutoresizingMaskIntoConstraints = false
        friendImageIcon.contentMode = .scaleAspectFill
        friendImageIcon.layer.cornerRadius = 16
        friendImageIcon.layer.masksToBounds = true
        let constraints = [
            friendImageIcon.leadingAnchor.constraint(equalTo: friendImageButton.leadingAnchor),
            friendImageIcon.centerYAnchor.constraint(equalTo: friendImageButton.centerYAnchor),
            friendImageIcon.heightAnchor.constraint(equalToConstant: 32),
            friendImageIcon.widthAnchor.constraint(equalToConstant: 32)
        ]
        NSLayoutConstraint.activate(constraints)
        friendImageButton.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: friendImageButton)
    }
    
    func setupContainer(height: CGFloat){
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.backgroundColor = .white
        view.addSubview(messageContainer)
        containerBottomAnchor = messageContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containterHAnchor = messageContainer.heightAnchor.constraint(equalToConstant: height)
        let constraints = [
            messageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerBottomAnchor,
            containterHAnchor,
            messageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupImageClipButton(_ const: CGFloat){
        clipImageButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
        messageContainer.addSubview(clipImageButton)
        clipImageButton.tintColor = .black
        clipImageButton.contentMode = .scaleAspectFill
        clipImageButton.addTarget(self, action: #selector(clipImageButtonPressed), for: .touchUpInside)
        clipImageButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            clipImageButton.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 8),
            clipImageButton.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -messageContainer.frame.size.height - const),
            clipImageButton.widthAnchor.constraint(equalToConstant: 30),
            clipImageButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupSendButton(_ const: CGFloat){
        messageContainer.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.alpha = 0
        sendButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        sendButton.backgroundColor = .black
        sendButton.layer.cornerRadius = 15
        sendButton.layer.masksToBounds = true
        sendButton.tintColor = .white
        let constraints = [
            sendButton.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -messageContainer.frame.size.height - const),
            sendButton.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -8),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
        ]
        NSLayoutConstraint.activate(constraints)
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    func setupMicrophone(_ const: CGFloat){
        messageContainer.addSubview(micButton)
        micButton.translatesAutoresizingMaskIntoConstraints = false
        micButton.setImage(UIImage(systemName: "mic"), for: .normal)
        micButton.tintColor = .black
        micButton.addTarget(self, action: #selector(startAudioRec), for: .touchUpInside)
        let constraints = [
            micButton.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -messageContainer.frame.size.height - const),
            micButton.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -8),
            micButton.heightAnchor.constraint(equalToConstant: 30),
            micButton.widthAnchor.constraint(equalToConstant: 30),
        ]
        NSLayoutConstraint.activate(constraints)
        micButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    func setupMessageTF(_ const: CGFloat){
        messageContainer.addSubview(messageTV)
        messageTV.layer.cornerRadius = 12
        messageTV.font = UIFont(name: "Helvetica Neue", size: 16)
        messageTV.textColor = .black
        messageTV.isScrollEnabled = false
        messageTV.layer.borderWidth = 0.2
        messageTV.layer.borderColor = UIColor.systemGray.cgColor
        messageTV.layer.masksToBounds = true
        let messTFPlaceholder = UILabel()
        messTFPlaceholder.text = "Message"
        messTFPlaceholder.font = UIFont(name: "Helvetica Neue", size: 16)
        messTFPlaceholder.sizeToFit()
        messageTV.addSubview(messTFPlaceholder)
        messTFPlaceholder.frame.origin = CGPoint(x: 10, y: 6)
        messTFPlaceholder.textColor = .lightGray
        messageTV.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 10)
        messageTV.translatesAutoresizingMaskIntoConstraints = false
        messageTV.backgroundColor = UIColor(white: 0.95, alpha: 1)
        messageTV.adjustsFontForContentSizeCategory = true
        messageTV.delegate = self
        let constraints = [
            messageTV.leadingAnchor.constraint(equalTo: clipImageButton.trailingAnchor, constant: 8),
            messageTV.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            messageTV.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -messageContainer.frame.size.height - const),
            messageTV.heightAnchor.constraint(equalToConstant: 32)
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
            chatNetworking.uploadImage(image: originalImage)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func openImagePicker(type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        present(picker, animated: true, completion: nil)
    }
    
    @objc func sendButtonPressed(){
        setupTextMessage()
    }
    
    func setupTextMessage(){
        let trimmedMessage = messageTV.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedMessage.count > 0 else { return }
        let senderRef = Constants.db.reference().child("messages").child(CurrentUser.uid).child(friend.id).childByAutoId()
        let friendRef = Constants.db.reference().child("messages").child(friend.id).child(CurrentUser.uid).child(senderRef.key!)
        guard let messageId = senderRef.key else { return }
        var values = ["message": trimmedMessage, "sender": CurrentUser.uid!, "recipient": friend.id!, "time": Date().timeIntervalSince1970, "messageId": messageId] as [String : Any]
        if userResponse.repliedMessage != nil || userResponse.messageToForward != nil{
            let repValues = userResponse.messageToForward != nil ? userResponse.messageToForward : userResponse.repliedMessage
            if repValues?.message != nil {
                values["repMessage"] = repValues?.message
            }else if repValues?.mediaUrl != nil{
                values["repMediaMessage"] = repValues?.mediaUrl
            }
            values["repMID"] = repValues?.id
            values["repSender"] = userResponse.messageSender
            exitResponseButtonPressed()
        }
        chatNetworking.sendMessageHandler(senderRef: senderRef, friendRef: friendRef, values: values) { (error) in
            self.handleMessageTextSent(error)
        }
    }
    
    func handleMessageTextSent(_ error: Error?){
        guard error == nil else {
            showAlert(title: "Error", message: error?.localizedDescription)
            return
        }
        messageTV.text = ""
        messageTV.subviews[2].isHidden = false
        chatNetworking.disableIsTyping()
        hideKeyboard()
        messageTV.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = 32
                messageContainer.constraints.forEach { (const) in if const.firstAttribute == .height {
                    if sendingIsFinished(const: const){ return }
                    }
                }
            }
            view.layoutIfNeeded()
        }
    }
    
    func setupLoadMoreIndicator(_ const: CGFloat){
        refreshIndicator.hidesWhenStopped = true
        var topConst: CGFloat = 90
        if const == 8 {
            topConst = 70
        }
        refreshIndicator.color = .black
        view.addSubview(refreshIndicator)
        refreshIndicator.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            refreshIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: topConst),
            refreshIndicator.widthAnchor.constraint(equalToConstant: 25),
            refreshIndicator.heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func fetchMessages(){
        chatNetworking.loadMore = true
        chatNetworking.scrollToIndex = []
        chatNetworking.getMessages(view, messages) { (newMessages, order) in
            self.chatNetworking.lastMessageReached = newMessages.count == 0
            if self.chatNetworking.lastMessageReached {
                print("message.count == 0")
                self.chatNetworking.loadNewMessages = true
                return
            }
            self.chatNetworking.scrollToIndex = newMessages
            self.chatNetworking.timer.invalidate()
            self.refreshIndicator.startAnimating()
            if order {
                self.refreshIndicator.order = order
                self.messages.append(contentsOf: newMessages)
            }else{
                self.refreshIndicator.order = order
                self.messages.insert(contentsOf: newMessages, at: 0)
            }
            self.chatNetworking.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
        }
    }
    
    func observeMessageActions(){
        let ref = Database.database().reference().child("messages").child(CurrentUser.uid).child(friend.id)
        ref.observe(.childRemoved) { (snap) in
            self.chatNetworking.deleteMessageHandler(self.messages, for: snap) { (index) in
                self.messages.remove(at: index)
                self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
        }
        ref.observe(.childAdded) { (snap) in
            self.chatNetworking.newMessageRecievedHandler(self.chatNetworking.loadNewMessages, self.messages, for: snap) { (newMessage) in
                self.messages.append(newMessage)
                self.collectionView.reloadData()
                self.scrollToTheBottom(animated: true)
            }
        }
    }
    
    @objc func handleReload(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.refreshIndicator.order{
                self.scrollToTheBottom(animated: false)
            }else{
                let index = self.chatNetworking.scrollToIndex.count - 1
                self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .top, animated: false)
            }
            self.chatNetworking.loadMore = false
            self.refreshIndicator.stopAnimating()
            if self.messages.count >= 1 { self.chatNetworking.loadNewMessages = true }
        }
    }
    
    @objc func profileImageTapped(){
        print("TODO: Friend Profile")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonPressed()
        return true
    }
    
    func zoomImageHandler(image: UIImageView){
        view.endEditing(true)
        imageGalleryView.frame = image.superview?.convert(image.frame, to: nil)
        let photoView = UIImageView(frame: imageGalleryView.frame!)
        imageGalleryView.startingFrame = image
        imageGalleryView.startingFrame.isHidden = true
        photoView.isUserInteractionEnabled = true
        let slideUp = UISwipeGestureRecognizer(target: self, action: #selector(imageSlideUpDownHandler(tap:)))
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(imageSlideUpDownHandler(tap:)))
        slideUp.direction = .up
        slideDown.direction = .down
        photoView.addGestureRecognizer(slideUp)
        photoView.addGestureRecognizer(slideDown)
        photoView.image = image.image
        let keyWindow = UIApplication.shared.windows[0]
        imageGalleryView.background = UIView(frame: keyWindow.frame)
        imageGalleryView.background.backgroundColor = .black
        imageGalleryView.background.alpha = 0
        keyWindow.addSubview(imageGalleryView.background)
        keyWindow.addSubview(photoView)
        let closeImageButton = UIButton(type: .system)
        imageGalleryView.clickedView = photoView
        imageGalleryView.background.addSubview(closeImageButton)
        closeImageButton.translatesAutoresizingMaskIntoConstraints = false
        closeImageButton.tintColor = .white
        closeImageButton.addTarget(self, action: #selector(closeImageButtonPressed), for: .touchUpInside)
        closeImageButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        
        var tAnchor = closeImageButton.topAnchor.constraint(equalTo: imageGalleryView.background.topAnchor, constant: 20)
        if imageGalleryView.background.safeAreaInsets.top > 25 {
            tAnchor = closeImageButton.topAnchor.constraint(equalTo: imageGalleryView.background.topAnchor, constant: 45)
        }
        let constraints = [
            closeImageButton.trailingAnchor.constraint(equalTo: imageGalleryView.background.trailingAnchor, constant: -16),
            tAnchor
        ]
        NSLayoutConstraint.activate(constraints)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.imageGalleryView.background.alpha = 1
            let height = self.imageGalleryView.frame!.height / self.imageGalleryView.frame!.width * keyWindow.frame.width
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
        let slideView = imageGalleryView.clickedView
        handleZoomOutAnim(slideView: slideView!)
    }
    
    func handleZoomOutAnim(slideView: UIImageView){
        slideView.layer.cornerRadius = 16
        slideView.layer.masksToBounds = true
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            slideView.frame = self.imageGalleryView.frame!
            self.imageGalleryView.background.alpha = 0
        }) { (true) in
            slideView.alpha = 0
            slideView.removeFromSuperview()
            self.imageGalleryView.startingFrame.isHidden = false
        }
    }
    
    func messageContainerHeightHandler(_ const: NSLayoutConstraint, _ estSize: CGSize){
        if sendingIsFinished(const: const) { return }
        var height = estSize.height
        if userResponse.responseStatus { height = estSize.height + 50 }
        if height > 150 { return }
        if messageTV.calculateLines() >= 2 {
            if containerHeight > 45 {
                const.constant = height + 35
            }else{ const.constant = height + 15 }
        }
    }
    
    func messageHeightHandler(_ constraint: NSLayoutConstraint, _ estSize: CGSize){
        let height: CGFloat = userResponse.responseStatus == true ? 100 : 150
        if estSize.height > height{
            messageTV.isScrollEnabled = true
            return
        }else if messageTV.calculateLines() < 2 {
            constraint.constant = 32
            self.view.layoutIfNeeded()
            return
        }
        constraint.constant = estSize.height
        self.view.layoutIfNeeded()
    }
    
    func sendingIsFinished(const: NSLayoutConstraint) -> Bool{
        let height: CGFloat = userResponse.responseStatus == true ? containerHeight + 50 : containerHeight
        if messageTV.text.count == 0 {
            messageTV.isScrollEnabled = false
            const.constant = height
            return true
        }else{
            return false
        }
    }
    
    func notificationCenterHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func willResignActive(_ notification: Notification) {
        chatNetworking.disableIsTyping()
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height, let duration = kDuration else { return }
        if containerHeight > 45 {
            containerBottomAnchor.constant = 13.2
            collectionView.contentOffset.y -= 13.2
        }
        collectionView.contentOffset.y += height
        containerBottomAnchor.constant -= height
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height else { return }
        guard let duration = kDuration else { return }
        if containerHeight > 45 {
            collectionView.contentOffset.y += 13.2
        }
        collectionView.contentOffset.y -= height
        containerBottomAnchor.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func animateActionButton(){
        var buttonToAnimate = UIButton()
        if messageTV.text.count >= 1 {
            micButton.alpha = 0
            if sendButton.alpha == 1 { return }
            sendButton.alpha = 1
            buttonToAnimate = sendButton
        }else if messageTV.text.count == 0{
            micButton.alpha = 1
            sendButton.alpha = 0
            buttonToAnimate = micButton
        }
        buttonToAnimate.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            buttonToAnimate.transform = .identity
        })
    }
    
    func observeFriendTyping(){
        chatNetworking.observeIsUserTyping() { (friendActivity) in
            if friendActivity.friendId == self.friend.id && friendActivity.isTyping {
                self.navigationItem.setupTypingNavTitle(navTitle: self.friend.name)
            }else{
                self.setupChatNavBar()
            }
        }
    }
    
    func scrollToTheBottom(animated: Bool){
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    func setuplongPress(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(longPress:)))
        gesture.delegate = self
        gesture.delaysTouchesBegan = true
        gesture.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture(longPress: UILongPressGestureRecognizer){
        if longPress.state != UIGestureRecognizer.State.began { return }
        let point = longPress.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChatCell else { return }
        let message = messages[indexPath.row]
        openToolsMenu(indexPath, message, cell)
    }
    
    func toolMessageAppearance(_ window: CGRect, _ tV: UIView, _ mV: UIView, _ nS: Bool, _ h: CGFloat){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if tV.frame.maxY > window.maxY && nS{
                tV.frame.origin.y = window.maxY - 220
                mV.frame.origin.y = tV.frame.minY - h - 8
            }else if mV.frame.minY < 100 && nS{
                mV.frame.origin.y = window.minY + 40
                tV.frame.origin.y = mV.frame.maxY + 8
            }
        })
    }
    
    func forwardButtonPressed(_ message: Messages) {
        chatNetworking.getMessageSender(message: message) { (name) in
            self.userResponse.messageToForward = message
            let convController = NewConversationVC()
            convController.delegate = self
            convController.forwardName = name
            let navController = UINavigationController(rootViewController: convController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func responseButtonPressed(_ message: Messages, forwardedName: String? = nil){
           responseViewChangeAlpha(a: 0)
           messageTV.becomeFirstResponder()
           userResponse.responseStatus = true
           userResponse.repliedMessage = message
           containterHAnchor.constant += 50
           UIView.animate(withDuration: 0.1, animations: {
               self.view.layoutIfNeeded()
               self.responseMessageLine(message, forwardedName)
           }) { (true) in
               self.responseViewChangeAlpha(a: 1)
           }
       }
    
}

extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = messages[indexPath.row]
        if let msg = message.message {
            height = calculateFrameInText(message: msg).height + 10
            if message.repMediaMessage != nil || message.repMessage != nil { height += 50 }
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
        cell.msg = message
        if let message = message.message {
            cell.backgroundWidthAnchor.constant = calculateFrameInText(message: message).width + 32
        }
        
        if message.recipient == CurrentUser.uid{
            cell.isIncoming = true
            cell.outcomingMessage.isActive = false
            cell.incomingMessage.isActive = true
        }else{
            cell.isIncoming = false
            cell.incomingMessage.isActive = false
            cell.outcomingMessage.isActive = true
        }
        
        if message.mediaUrl != nil{
            cell.mediaMessage.loadImage(url: message.mediaUrl)
            cell.mediaMessage.isHidden = false
            cell.backgroundWidthAnchor.constant = 200
            cell.messageBackground.backgroundColor = .clear
        }else{
            cell.mediaMessage.isHidden = true
        }
        
        if message.repMediaMessage != nil {
            cell.setupRepMessageView(message.repSender)
        }else if message.repMessage != nil {
            cell.setupRepMessageView(message.repSender)
        }else{
            cell.removeReplyOutlets()
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let sView = scrollView as? UICollectionView else { return }
        if sView.contentOffset.y + sView.adjustedContentInset.top == 0 {
            if !chatNetworking.loadMore && !chatNetworking.lastMessageReached {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                fetchMessages()
            }
        }
    }
    
}

extension ChatVC: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        chatNetworking.disableIsTyping()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        chatNetworking.isTypingHandler(tV: textView)
        animateActionButton()
        if !messageTV.text.isEmpty {
            messageTV.subviews[2].isHidden = true
        }else{
            messageTV.subviews[2].isHidden = false
        }
        let size = CGSize(width: textView.frame.width, height: 150)
        let estSize = textView.sizeThatFits(size)
        messageTV.constraints.forEach { (constraint) in
            if constraint.firstAttribute != .height { return }
            messageHeightHandler(constraint, estSize)
            messageContainer.constraints.forEach { (const) in if const.firstAttribute == .height { messageContainerHeightHandler(const, estSize) }}
        }
    }
}

extension ChatVC: ForwardToFriend {
    
    func forwardToSelectedFriend(friend: FriendInfo, for name: String) {
        responseButtonPressed(userResponse.messageToForward!, forwardedName: name)
        self.friend = friend
        messages = []
        collectionView.reloadData()
        chatNetworking.loadNewMessages = false
        setupChat()
    }
    
}
