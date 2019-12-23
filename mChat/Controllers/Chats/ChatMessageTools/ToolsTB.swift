//
//  ToolsTB.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ToolsTB: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var tools = ["Reply", "Forward", "Copy", "Delete"]
    var toolsImg = ["arrowshape.turn.up.left", "arrowshape.turn.up.right", "doc.on.doc", "trash"]
    var blurView: ToolsBlurView!
    var chatView: ChatVC!
    var selectedMessage: Messages!
    var indexPath: IndexPath!
    
    init(frame: CGRect, style: UITableView.Style, tV: UIView, bV: ToolsBlurView, cV: ChatVC, sM: Messages, i: IndexPath) {
        super.init(frame: frame, style: style)
        blurView = bV
        chatView = cV
        indexPath = i
        selectedMessage = sM
        delegate = self
        dataSource = self
        register(ToolsCell.self, forCellReuseIdentifier: "ToolsCell")
        separatorStyle = .singleLine
        translatesAutoresizingMaskIntoConstraints = false
        rowHeight = 50
        tV.addSubview(self)
        let tableConstraints = [
            leadingAnchor.constraint(equalTo: tV.leadingAnchor, constant: -16),
            bottomAnchor.constraint(equalTo: tV.bottomAnchor),
            trailingAnchor.constraint(equalTo: tV.trailingAnchor, constant: 16),
            topAnchor.constraint(equalTo: tV.topAnchor),
        ]
        NSLayoutConstraint.activate(tableConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolsCell") as! ToolsCell
        cell.toolName.text = tools[indexPath.row]
        cell.toolImg.image = UIImage(systemName: toolsImg[indexPath.row])
        if tools[indexPath.row] == "Delete" {
            cell.toolName.textColor = .red
            cell.toolImg.tintColor =  .red
        }else{
            cell.toolImg.tintColor = .black
            cell.toolName.textColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tool = tools[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        if "Delete" == tool {
            removeMessageHandler()
        }else{
            print("do nothing")
        }
    }
 
    func removeMessageHandler(){
        for message in chatView.messages{
            if message.id == selectedMessage.id{
                self.chatView.messageRemoved = true
                Database.database().reference().child("message-Ids").child(CurrentUser.uid).child(message.determineUser()).child(selectedMessage.id).removeValue { (error, ref) in
                    Database.database().reference().child("message-Ids").child(message.determineUser()).child(CurrentUser.uid).child(self.selectedMessage.id).removeValue()
                    guard error == nil else { return }
                    self.chatView.messages.remove(at: self.indexPath.row)
                    self.chatView.collectionView.deleteItems(at: [self.indexPath])
                    self.blurView.handleViewDismiss(isDeleted: true)
                }
            }
        }
    }
    
}
