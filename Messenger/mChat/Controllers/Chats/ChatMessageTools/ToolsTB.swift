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

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var tools = ["Reply", "Forward", "Copy", "Delete"]
    var toolsImg = ["arrowshape.turn.up.left", "arrowshape.turn.up.right", "doc.on.doc", "trash"]
    var selectedMessage: Messages!
    var scrollView: ToolsMenu!
    var selectedCell: ChatCell!
    var chatView: ChatVC!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(style: UITableView.Style, sV: ToolsMenu) {
        super.init(frame: sV.toolsView.frame, style: style)
        selectedMessage = sV.message
        if selectedMessage.mediaUrl != nil || selectedMessage.audioUrl != nil{
            tools.remove(at: 2)
            toolsImg.remove(at: 2)
        }
        scrollView = sV
        chatView = sV.chatVC
        selectedCell = sV.selectedCell
        delegate = self
        dataSource = self
        register(ToolsCell.self, forCellReuseIdentifier: "ToolsCell")
        separatorStyle = .singleLine
        translatesAutoresizingMaskIntoConstraints = false
        rowHeight = 50
        let toolsView = sV.toolsView
        toolsView.addSubview(self)
        let tableConstraints = [
            leadingAnchor.constraint(equalTo: toolsView.leadingAnchor, constant: -16),
            bottomAnchor.constraint(equalTo: toolsView.bottomAnchor),
            trailingAnchor.constraint(equalTo: toolsView.trailingAnchor, constant: 16),
            topAnchor.constraint(equalTo: toolsView.topAnchor),
        ]
        NSLayoutConstraint.activate(tableConstraints)
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tools.count
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
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

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
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
            scrollView.handleViewDismiss()
        }else if "Reply" == tool{
            if repliedMesage != nil || messageToForward != nil{ chatView.exitResponseButtonPressed() }
            scrollView.handleViewDismiss(isReply: true)
        }else if "Forward" == tool{
            if repliedMesage != nil || messageToForward != nil{ chatView.exitResponseButtonPressed() }
            scrollView.handleViewDismiss(isForward: true)
        }
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func removeHandler(){
        chatView.chatNetworking.removeMessageHandler(messageToRemove: selectedMessage) {
            self.scrollView.handleViewDismiss(isDeleted: true)
        }

    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
