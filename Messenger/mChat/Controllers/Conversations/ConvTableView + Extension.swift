//
//  ConvTableView + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/7/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

extension ConversationsVC: UITableViewDelegate, UITableViewDataSource {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupNoTypingCell(_ cell: ConversationsCell){
        cell.isTypingView.isHidden = true
        cell.recentMessage.isHidden = false
        cell.timeLabel.isHidden = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationsCell") as! ConversationsCell
        cell.selectionStyle = .none
        let recent = messages[indexPath.row]
        cell.convVC = self
        cell.message = recent
        cell.unreadMessageView.isHidden = true
        convNetworking.observeUnreadMessages(recent.determineUser()) { (unreadMessage) in
            if let numOfMessages = unreadMessage[cell.message!.determineUser()], numOfMessages > 0 {
                cell.unreadMessageView.isHidden = false
                cell.unreadLabel.text = "\(numOfMessages)"
            }else{
                cell.unreadMessageView.isHidden = true
            }
        }
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chat = messages[indexPath.row]
        for usr in Friends.list {
            if usr.id == chat.determineUser() {
                nextControllerHandler(usr: usr)
                break
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
