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

class ChatVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    var friendId: String!
    var friendName: String!
    var friendEmail: String!
    var friendProfileImage: String!
    var friendIsOnline: Bool!
    var friendLastLogin: NSNumber!
    var messages = [Messages]()
    var loadNewMessages = false
    var friendActivity = [FriendActivity]()
    var imageToSend: UIImage!
    
    var containerHeight: CGFloat!
    var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), collectionViewLayout: UICollectionViewFlowLayout.init())
    var messageContainer = UIView()
    var clipImageButton = UIButton(type: .system)
    var sendButton = UIButton(type: .system)
    var micButton = UIButton(type: .system)
    var messageTF = UITextView()
    var isTypingView = UIView()
    let typingAnimation = AnimationView()
    let calendar = Calendar(identifier: .gregorian)
    var imgFrame: CGRect?
    var imgBackground: UIView!
    var imageClickedView: UIImageView!
    var startingImageFrame: UIImageView!
    var loadMore = false
    var lastMessageReached = false
    var scrollToIndex = [Messages]()
    var refreshIndicator = RefreshIndicator(style: .medium)
    var timer = Timer()
    var toolsBlurView = ToolsBlurView()
    var toolsScrollView = UIScrollView()
    let vGenerator = UIImpactFeedbackGenerator(style: .medium)
    var replyStatus = false
    var repliedMessage: Messages?
    var forwardedMessage: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        setupChatNavBar()
        fetchMessages()
        observeMessageActions()
        notificationCenterHandler()
        hideKeyboardOnTap(collectionView)
        observeIsUserTyping()
        setuplongPress()
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
        setupProfileImage()
        setupLoadMoreIndicator(topConst)
    }
    
    func setupChatNavBar(){
        let loginDate = NSDate(timeIntervalSince1970: friendLastLogin.doubleValue)
        navigationController?.navigationBar.tintColor = .black
        if friendIsOnline {
            navigationItem.setNavTitles(navTitle: friendName, navSubtitle: "Online")
        }else{
            navigationItem.setNavTitles(navTitle: friendName, navSubtitle: calendar.calculateLastLogin(loginDate))
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
    var containterHAnchor = NSLayoutConstraint()
    func setupContainer(height: CGFloat){
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.backgroundColor = .white
        view.addSubview(messageContainer)
        let topLine = UIView()
        topLine.backgroundColor = UIColor(displayP3Red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        topLine.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.addSubview(topLine)
        containerBottomAnchor = messageContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containterHAnchor = messageContainer.heightAnchor.constraint(equalToConstant: height)
        let constraints = [
            messageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerBottomAnchor,
            containterHAnchor,
            messageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLine.leftAnchor.constraint(equalTo: view.leftAnchor),
            topLine.rightAnchor.constraint(equalTo: view.rightAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 0.5)
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
            messageTF.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -messageContainer.frame.size.height - const),
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
        let senderRef = Constants.db.reference().child("messages").child(CurrentUser.uid).child(friendId).childByAutoId()
        let friendRef = Constants.db.reference().child("messages").child(friendId).child(CurrentUser.uid).child(senderRef.key!)
        guard let messageId = senderRef.key else { return }
        let values = ["sender": CurrentUser.uid!, "time": Date().timeIntervalSince1970, "recipient": friendId!, "mediaUrl": url, "width": image.size.width, "height": image.size.height, "messageId": messageId] as [String: Any]
        sendMessageHandler(senderRef: senderRef, friendRef: friendRef,values: values)
    }
    
    @objc func sendButtonPressed(){
        let trimmedMessage = messageTF.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedMessage.count > 0 else { return }
        let senderRef = Constants.db.reference().child("messages").child(CurrentUser.uid).child(friendId).childByAutoId()
        let friendRef = Constants.db.reference().child("messages").child(friendId).child(CurrentUser.uid).child(senderRef.key!)
        guard let messageId = senderRef.key else { return }
        var values = ["message": trimmedMessage, "sender": CurrentUser.uid!, "recipient": friendId!, "time": Date().timeIntervalSince1970, "messageId": messageId] as [String : Any]
        if repliedMessage != nil{
            if repliedMessage?.message != nil {
                values["repMessage"] = repliedMessage!.message
            }else if repliedMessage?.mediaUrl != nil{
                values["repMediaMessage"] = repliedMessage!.mediaUrl
            }
            values["repMID"] = repliedMessage!.id
            exitReplyButtonPressed()
        }
        sendMessageHandler(senderRef: senderRef, friendRef: friendRef, values: values)
        messageTF.text = ""
        messageTF.subviews[2].isHidden = false
    }
    
    func sendMessageHandler(senderRef: DatabaseReference, friendRef: DatabaseReference,  values: [String: Any]){
        senderRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            friendRef.updateChildValues(values)
        }
        self.messageTF.text = ""
        disableIsTyping()
        hideKeyboard()
        messageTF.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = 32
                messageContainer.constraints.forEach { (const) in if const.firstAttribute == .height {
                    if sendingIsFinished(const: const){ return }}}}
            self.view.layoutIfNeeded()
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
        loadMore = true
        scrollToIndex = []
        getMessages{ (newMessages, order) in
            self.lastMessageReached = newMessages.count == 0
            if self.lastMessageReached {
                print("hello?")
                self.loadNewMessages = true
                return
            }
            self.scrollToIndex = newMessages
            self.timer.invalidate()
            self.refreshIndicator.startAnimating()
            if order {
                self.refreshIndicator.order = order
                self.messages.append(contentsOf: newMessages)
            }else{
                self.refreshIndicator.order = order
                self.messages.insert(contentsOf: newMessages, at: 0)
            }
            self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
        }
    }
    
    func getMessages(completion: @escaping(_ newMessages: [Messages], _ mOrder: Bool) -> Void){
        var nodeRef: DatabaseQuery
        var messageOrder = true
        var newMessages = [Messages]()
        var messageCount: UInt = 20
        if view.frame.height > 1000 { messageCount = 40 }
        let firstMessage = self.messages.first
        if firstMessage == nil{
            nodeRef = Database.database().reference().child("messages").child(CurrentUser.uid).child(friendId).queryOrderedByKey().queryLimited(toLast: messageCount)
            messageOrder = true
        }else{
            let mId = firstMessage!.id
            nodeRef = Database.database().reference().child("messages").child(CurrentUser.uid).child(friendId).queryOrderedByKey().queryEnding(atValue: mId).queryLimited(toLast: messageCount)
            messageOrder = false
        }
        nodeRef.observeSingleEvent(of: .value) { (snap) in
            for child in snap.children {
                guard let snapshot = child as? DataSnapshot else { return }
                if firstMessage?.id != snapshot.key {
                    guard let values = snapshot.value as? [String: Any] else { return }
                    newMessages.append(self.setupUserMessage(for: values))
                }
            }
            return completion(newMessages, messageOrder)
        }
    }
    
    func observeMessageActions(){
        let ref =  Database.database().reference().child("messages").child(CurrentUser.uid).child(friendId)
        ref.observe(.childRemoved) { (snap) in
            self.deletedMessageHandler(for: snap)
        }
        ref.observe(.childAdded) { (snap) in
            self.newMessageHandler(for: snap)
        }
    }
    
    func deletedMessageHandler(for snap: DataSnapshot){
        var index = 0
        for message in self.messages {
            if message.id == snap.key {
                self.messages.remove(at: index)
                self.collectionView.reloadData()
            }
            index += 1
        }
    }
    
    func newMessageHandler(for snap: DataSnapshot){
        if self.loadNewMessages {
            print("GIFDf")
            let status = self.messages.contains { (message) -> Bool in return message.id == snap.key }
            if !status {
                guard let values = snap.value as? [String: Any] else { return }
                let newMessage = self.setupUserMessage(for: values)
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
                let index = self.scrollToIndex.count - 1
                self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .top, animated: false)
            }
            self.loadMore = false
            self.refreshIndicator.stopAnimating()
            if self.messages.count >= 1 { self.loadNewMessages = true }
        }
    }
    
    @objc func profileImageTapped(){
        print("TODO: Friend Profile")
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
        var height = estSize.height
        if replyStatus { height = estSize.height + 50 }
        if height > 150 { return }
        if messageTF.calculateLines() >= 2 {
            if containerHeight > 45 {
                const.constant = height + 35
            }else{ const.constant = height + 15 }
        }
    }
    
    func messageHeightHandler(_ constraint: NSLayoutConstraint, _ estSize: CGSize){
        let height: CGFloat = replyStatus == true ? 100 : 150
        if estSize.height > height{
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
        let height: CGFloat = replyStatus == true ? containerHeight + 50 : containerHeight
        if messageTF.text.count == 0 {
            messageTF.isScrollEnabled = false
            const.constant = height
            return true
        }else{
            return false
        }
    }
    
    func animateMessageContainer(){
        self.view.layoutIfNeeded()
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
                self.navigationItem.setupTypingNavTitle(navTitle: self.friendName)
            }else{
                self.animateTyping(const: 0, isHidden: true)
                self.setupChatNavBar()
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
    
    func scrollToTheBottom(animated: Bool){
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    func disableIsTyping(){
        guard let friendId = friendId , let user = CurrentUser.uid else { return }
        let userRef = Database.database().reference().child("userActions").child(CurrentUser.uid).child(friendId)
        userRef.updateChildValues(["isTyping": false, "fromFriend": user])
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
    
    func openToolsMenu(_ indexPath: IndexPath, _ message: Messages, _ selectedCell: ChatCell){
        hideKeyboard()
        selectedCell.isHidden = true
        let window = UIApplication.shared.windows[0]
        let cF = collectionView.convert(selectedCell.frame, to: collectionView.superview)
        let bF = collectionView.convert(selectedCell.messageBackground.frame, to: collectionView.superview)
        let w = selectedCell.messageBackground.frame.size.width
        let h = selectedCell.messageBackground.frame.size.height
        toolsScrollView = setupScrollView(h)
        toolsBlurView = setupBlurView()
        window.addSubview(toolsScrollView)
        toolsScrollView.addSubview(toolsBlurView)
        var xValue: CGFloat = bF.origin.x
        if !selectedCell.isIncoming, bF.width < 190 {
            xValue = bF.minX - 150
            let width = bF.width
            if  width < 190, width > 120 { xValue = bF.origin.x - 90 }
        }
        var scrollYValue = cF.maxY + 8
        var messageYValue = cF.origin.y
        let noScroll = self.toolsScrollView.contentSize.height == self.view.frame.height
        if !noScroll {
            scrollYValue = h
            messageYValue = toolsScrollView.frame.minY - 8
            toolsScrollView.setContentOffset(CGPoint(x: 0, y: max(toolsScrollView.contentSize.height - toolsScrollView.bounds.size.height, 0) ), animated: true)
        }
        let toolsView = ToolsView(frame: CGRect(x: xValue, y: scrollYValue, width: 200, height: 200))
        toolsScrollView.addSubview(toolsView)
        let _ = ToolsTB(frame: toolsView.frame, style: .plain, tV: toolsView, bV: toolsBlurView, cV: self, sM: message, i: indexPath, cell: selectedCell)
        let msgViewFrame = CGRect(x: bF.origin.x, y: messageYValue, width: w, height: h)
        let messageView = MessageView(frame: msgViewFrame, cell: selectedCell, message: message, friendName: friendName)
        toolsScrollView.addSubview(messageView)
        toolMessageAppearance(window.frame, toolsView, messageView, noScroll, h)
        toolsBlurView.cell = selectedCell
        toolsBlurView.message = message
        toolsBlurView.mView = messageView
        toolsBlurView.tView = toolsView
        toolsBlurView.backgroundFrame = bF
        toolsBlurView.cellFrame = cF
        toolsBlurView.sView = toolsScrollView
        toolsBlurView.chatView = self
        vGenerator.impactOccurred()
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
    
    func setupBlurView() -> ToolsBlurView{
        let blurView = ToolsBlurView()
        blurView.effect = UIBlurEffect(style: .dark)
        let size = toolsScrollView.contentSize
        blurView.frame = CGRect(x: 0, y: -400, width: size.width, height: size.height + 1000)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setupExitMenu))
        blurView.addGestureRecognizer(tapGesture)
        return blurView
    }
    
    func setupScrollView(_ height: CGFloat) -> UIScrollView{
        let scrollView = UIScrollView()
        scrollView.frame = view.frame
        var sHeight: CGFloat
        scrollView.backgroundColor = .clear
        if height < view.frame.height - 220 { sHeight = view.frame.height } else { sHeight = height + 230 }
        scrollView.contentSize = CGSize(width: view.frame.width, height: sHeight)
        return scrollView
    }
    
    @objc func setupExitMenu(){
        toolsBlurView.handleViewDismiss()
    }
    
    // Reply outlets
    
    let replyLine = UIView()
    let replyNameLabel = UILabel()
    var replyNameLabelConstraint: NSLayoutConstraint!
    let replyMessageLabel = UILabel()
    let replyMediaMessage = UIImageView()
    let exitReplyMessage = UIButton(type: .system)
    
    func replyButtonPressed(for cell: ChatCell, _ message: Messages){
        replyViewChangeAlpha(a: 0)
        messageTF.becomeFirstResponder()
        replyStatus = true
        repliedMessage = message
        containterHAnchor.constant += 50
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            self.replyMessageLine(message)
        }) { (true) in
            self.replyViewChangeAlpha(a: 1)
        }
    }
    
    func replyViewChangeAlpha(a: CGFloat){
        replyLine.alpha = a
        replyNameLabel.alpha = a
        replyMessageLabel.alpha = a
        replyMediaMessage.alpha = a
        exitReplyMessage.alpha = a
    }
    
    func replyMessageLine(_ message: Messages){
        replyLine.backgroundColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
        replyLine.layer.cornerRadius = 1
        replyLine.layer.masksToBounds = true
        messageContainer.addSubview(replyLine)
        replyLine.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            replyLine.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 8),
            replyLine.bottomAnchor.constraint(equalTo: messageTF.topAnchor, constant: -8),
            replyLine.leadingAnchor.constraint(equalTo: messageTF.leadingAnchor, constant: 8),
            replyLine.widthAnchor.constraint(equalToConstant: 2),
        ]
        NSLayoutConstraint.activate(constraints)
        exitReplyButton()
        replyMessageName(message)
    }
    
    func exitReplyButton(){
        messageContainer.addSubview(exitReplyMessage)
        exitReplyMessage.translatesAutoresizingMaskIntoConstraints = false
        exitReplyMessage.setImage(UIImage(systemName: "xmark"), for: .normal)
        exitReplyMessage.tintColor = .black
        let constraints = [
            exitReplyMessage.trailingAnchor.constraint(equalTo: messageTF.trailingAnchor, constant: -16),
            exitReplyMessage.centerYAnchor.constraint(equalTo: replyLine.centerYAnchor),
            exitReplyMessage.widthAnchor.constraint(equalToConstant: 12),
            exitReplyMessage.heightAnchor.constraint(equalToConstant: 12)
        ]
        exitReplyMessage.addTarget(self, action: #selector(exitReplyButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func exitReplyButtonPressed(){
        replyStatus = false
        repliedMessage = nil
        self.containterHAnchor.constant -= 50
        UIView.animate(withDuration: 0.3){
            self.replyLine.removeFromSuperview()
            self.exitReplyMessage.removeFromSuperview()
            self.replyNameLabel.removeFromSuperview()
            self.replyMediaMessage.removeFromSuperview()
            self.replyMessageLabel.removeFromSuperview()
        }
        
    }
    
    func replyMessageName(_ message: Messages){
        messageContainer.addSubview(replyNameLabel)
        replyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        replyNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        replyNameLabel.textColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
        let name = message.determineUser() == friendId ? friendName : CurrentUser.name
        replyNameLabel.text = name
        replyNameLabelConstraint = replyNameLabel.leadingAnchor.constraint(equalTo: replyLine.trailingAnchor, constant: 8)
        let constraints = [
            replyNameLabelConstraint!,
            replyNameLabel.trailingAnchor.constraint(equalTo: exitReplyMessage.trailingAnchor, constant: -8),
            replyNameLabel.topAnchor.constraint(equalTo: replyLine.topAnchor, constant: 4)
        ]
        NSLayoutConstraint.activate(constraints)
        setupReplyMessage(message)
    }
    
    func setupReplyMessage(_ message: Messages){
        if message.mediaUrl == nil {
            setupReplyTextM(message)
        }else{
            setupReplyMediaM(message)
        }
    }
    
    func setupReplyTextM(_ message: Messages){
        messageContainer.addSubview(replyMessageLabel)
        replyMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        replyMessageLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        replyMessageLabel.textColor = .black
        replyMessageLabel.text = message.message
        let constraints = [
            replyMessageLabel.leadingAnchor.constraint(equalTo: replyLine.trailingAnchor, constant: 8),
            replyMessageLabel.trailingAnchor.constraint(equalTo: exitReplyMessage.trailingAnchor, constant: -16),
            replyMessageLabel.topAnchor.constraint(equalTo: replyNameLabel.bottomAnchor, constant: -2),
            replyMessageLabel.bottomAnchor.constraint(equalTo: messageTF.topAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupReplyMediaM(_ message: Messages){
        let replyMediaLabel = UILabel()
        replyMediaLabel.text = "Image"
        replyMediaLabel.textColor = .gray
        replyMediaLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        messageContainer.addSubview(replyMediaMessage)
        replyMediaMessage.translatesAutoresizingMaskIntoConstraints = false
        replyMediaMessage.addSubview(replyMediaLabel)
        replyMediaLabel.translatesAutoresizingMaskIntoConstraints = false
        replyMediaMessage.loadImage(url: message.mediaUrl)
        replyNameLabelConstraint.constant += 34
        let constraints = [
            replyMediaMessage.topAnchor.constraint(equalTo: replyLine.topAnchor, constant: 2),
            replyMediaMessage.bottomAnchor.constraint(equalTo: replyLine.bottomAnchor, constant: -2),
            replyMediaMessage.widthAnchor.constraint(equalToConstant: 30),
            replyMediaMessage.leadingAnchor.constraint(equalTo: replyLine.trailingAnchor, constant: 8),
            replyMediaLabel.centerYAnchor.constraint(equalTo: replyMediaMessage.centerYAnchor, constant: 8),
            replyMediaLabel.leadingAnchor.constraint(equalTo: replyMediaMessage.trailingAnchor, constant: 4),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func showReplyMessageView(cell: ChatCell){
        var index = 0
        for message in messages {
            if message.id == cell.msg.repMID {
                let indexPath = IndexPath(row: index, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                break
            }
            index += 1
        }
    }
    
    func forwardButtonPressed(for: ChatCell, _ message: Messages) {
        let convController = UINavigationController(rootViewController: NewConversationVC())
        present(convController, animated: true, completion: nil)
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
            cell.setupRepMessageView(for: message, friendName)
        }else if message.repMessage != nil {
            cell.setupRepMessageView(for: message, friendName)
        }else{
            cell.removeReplyOutlets()
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let sView = scrollView as? UICollectionView else { return }
        if sView.contentOffset.y + sView.adjustedContentInset.top == 0 {
            if !loadMore && !lastMessageReached {
                vGenerator.impactOccurred()
                fetchMessages()
            }
        }
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
