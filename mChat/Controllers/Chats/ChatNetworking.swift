//
//  ChatNetworking.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/30/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ChatNetworking {
    
    var friend: FriendInfo!
    var loadMore = false
    var lastMessageReached = false
    var scrollToIndex = [Messages]()
    var timer = Timer()
    var loadNewMessages = false
    
    func getMessages(_ v: UIView, _ m: [Messages], completion: @escaping(_ newMessages: [Messages], _ mOrder: Bool) -> Void){
        var nodeRef: DatabaseQuery
        var messageOrder = true
        var newMessages = [Messages]()
        var messageCount: UInt = 20
        if v.frame.height > 1000 { messageCount = 40 }
        let firstMessage = m.first
        if firstMessage == nil{
            nodeRef = Database.database().reference().child("messages").child(CurrentUser.uid).child(friend.id).queryOrderedByKey().queryLimited(toLast: messageCount)
            messageOrder = true
        }else{
            let mId = firstMessage!.id
            nodeRef = Database.database().reference().child("messages").child(CurrentUser.uid).child(friend.id).queryOrderedByKey().queryEnding(atValue: mId).queryLimited(toLast: messageCount)
            messageOrder = false
        }
        nodeRef.observeSingleEvent(of: .value) { (snap) in
            for child in snap.children {
                guard let snapshot = child as? DataSnapshot else { return }
                if firstMessage?.id != snapshot.key {
                    guard let values = snapshot.value as? [String: Any] else { return }
                    newMessages.append(MessageKit.setupUserMessage(for: values))
                }
            }
            return completion(newMessages, messageOrder)
        }
    }
    
    func deleteMessageHandler(_ messages: [Messages], for snap: DataSnapshot, completion: @escaping (_ index: Int) -> Void){
        var index = 0
        print("Delete messages handler fired")
        for message in messages {
            if message.id == snap.key {
                return completion(index)
            }
            index += 1
        }
    }
    
    func removeMessageHandler(mId: String, completion: @escaping () -> Void){
        Database.database().reference().child("messages").child(CurrentUser.uid).child(friend.id).child(mId).removeValue { (error, ref) in
            Database.database().reference().child("messages").child(self.friend.id).child(CurrentUser.uid).child(mId).removeValue()
            guard error == nil else { return }
            return completion()
        }
    }
    
    func newMessageRecievedHandler(_ fetchStatus: Bool, _ messages: [Messages], for snap: DataSnapshot, completion: @escaping (_ message: Messages) -> Void){
        if fetchStatus {
            print("New messages handler fired")
            let status = messages.contains { (message) -> Bool in return message.id == snap.key }
            if !status {
                guard let values = snap.value as? [String: Any] else { return }
                let newMessage = MessageKit.setupUserMessage(for: values)
                return completion(newMessage)
            }
        }
    }
    
    func uploadImage(image: UIImage){
        let mediaName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("message-img").child(mediaName)
        if let jpegName = image.jpegData(compressionQuality: 0.1) {
            storageRef.putData(jpegName, metadata: nil) { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.downloadImage(storageRef, image)
            }
        }
    }
    
    private func downloadImage(_ ref: StorageReference, _ image: UIImage) {
        ref.downloadURL { (url, error) in
            guard let url = url else { return }
            self.sendMediaMessage(url: url.absoluteString, image)
        }
    }
    
    func sendMediaMessage(url: String, _ image: UIImage){
        let senderRef = Constants.db.reference().child("messages").child(CurrentUser.uid).child(friend.id).childByAutoId()
        let friendRef = Constants.db.reference().child("messages").child(friend.id).child(CurrentUser.uid).child(senderRef.key!)
        guard let messageId = senderRef.key else { return }
        let values = ["sender": CurrentUser.uid!, "time": Date().timeIntervalSince1970, "recipient": friend.id!, "mediaUrl": url, "width": image.size.width, "height": image.size.height, "messageId": messageId] as [String: Any]
        senderRef.updateChildValues(values)
        friendRef.updateChildValues(values)
    }
    
    func sendMessageHandler(senderRef: DatabaseReference, friendRef: DatabaseReference, values: [String: Any], completion: @escaping (_ error: Error?) -> Void){
        senderRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                completion(error)
            }
            friendRef.updateChildValues(values)
            completion(nil)
        }
    }
    
    func observeIsUserTyping(completion: @escaping (_ friendActivity: FriendActivity) -> Void){
        let db = Database.database().reference().child("userActions").child(friend.id).child(CurrentUser.uid)
        db.observe(.value) { (snap) in
            guard let data = snap.value as? [String: Any] else { return }
            guard let status = data["isTyping"] as? Bool else { return }
            guard let id = data["fromFriend"] as? String else { return }
            let friendActivity = FriendActivity(isTyping: status, friendId: id)
            return completion(friendActivity)
        }
    }
    
    func isTypingHandler(tV: UITextView){
        guard let friendId = friend.id , let user = CurrentUser.uid else { return }
        let userRef = Database.database().reference().child("userActions").child(CurrentUser.uid).child(friendId)
        if tV.text.count >= 1 {
            userRef.setValue(["isTyping": true, "fromFriend": user])
        }else{
            userRef.setValue(["isTyping": false, "fromFriend": user])
        }
    }
    
    func disableIsTyping(){
        guard let friendId = friend.id , let user = CurrentUser.uid else { return }
        let userRef = Database.database().reference().child("userActions").child(CurrentUser.uid).child(friendId)
        userRef.updateChildValues(["isTyping": false, "fromFriend": user])
    }
    
    func getMessageSender(message: Messages, completion: @escaping (_ sender: String) -> Void){
        Database.database().reference().child("messages").child(CurrentUser.uid).child(message.determineUser()).child(message.id).observeSingleEvent(of: .value) { (snap) in
            guard let values = snap.value as? [String: Any] else { return }
            let senderId = values["sender"] as? String
            guard let sender = senderId == CurrentUser.uid ? CurrentUser.name : self.friend.name else { return }
            completion(sender)
        }
    }
    
}
