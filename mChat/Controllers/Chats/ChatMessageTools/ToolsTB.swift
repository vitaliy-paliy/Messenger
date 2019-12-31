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
    var selectedCell: ChatCell!
    
    init(frame: CGRect, style: UITableView.Style, tV: UIView, bV: ToolsBlurView, cV: ChatVC, sM: Messages, i: IndexPath, cell: ChatCell) {
        super.init(frame: frame, style: style)
        blurView = bV
        chatView = cV
        indexPath = i
        selectedMessage = sM
        selectedCell = cell
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
        let tool = tools[indexPath.row]
        cell.toolName.text = tool
        cell.toolImg.image = UIImage(systemName: toolsImg[indexPath.row])
        if tool == "Delete" {
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
        let messageToForward = chatView.userResponse.messageToForward
        let repliedMesage = chatView.userResponse.repliedMessage
        tableView.deselectRow(at: indexPath, animated: true)
        if "Delete" == tool {
            removeHandler()
        }else if "Copy" == tool{
            guard selectedMessage.mediaUrl == nil else { return }
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = selectedMessage.message
            self.blurView.handleViewDismiss()
        }else if "Reply" == tool{
            if repliedMesage != nil || messageToForward != nil{ chatView.exitResponseButtonPressed() }
            blurView.handleViewDismiss(isReply: true)
        }else if "Forward" == tool{
            if repliedMesage != nil || messageToForward != nil{ chatView.exitResponseButtonPressed() }
            blurView.handleViewDismiss(isForward: true)
        }
    }
    
    func removeHandler(){
        chatView.chatNetworking.removeMessageHandler(mId: selectedMessage.id) {
            self.blurView.handleViewDismiss(isDeleted: true)
        }
        
    }
    
}
