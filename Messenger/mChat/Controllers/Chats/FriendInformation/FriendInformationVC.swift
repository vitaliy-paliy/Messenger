//
//  FriendInfoVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/2/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class FriendInformationVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // FriendInformationVC is shown when a user taps on the profile image located in the upper right corner in ChatVC.
    
    let calendar = Calendar(identifier: .gregorian)
    var friend: FriendInfo!
    let tableView = UITableView()
    
    let tools = ["Send Message", "Shared Media", "Open Maps"]
    let toolsImages = ["message_icon", "image_icon","map_icon"]
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Info"
        view.backgroundColor = .white
        setupTableView()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(FriendInformationCell.self, forCellReuseIdentifier: "friendInformationCell")
        tableView.register(FriendInformationToolsCell.self, forCellReuseIdentifier: "toolsCell")
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return tools.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendInformationCell", for: indexPath) as! FriendInformationCell
            tableView.rowHeight = 100
            cell.selectionStyle = .none
            if friend.isOnline ?? false {
                cell.onlineLabel.text = "Online"
            }else{
                let loginDate = NSDate(timeIntervalSince1970: (friend.lastLogin ?? 0).doubleValue)
                cell.onlineLabel.text = calendar.calculateLastLogin(loginDate)
            }
            cell.profileImage.loadImage(url: friend.profileImage ?? "")
            cell.nameLabel.text = friend.name
            return cell
        }else{
            tableView.rowHeight = 45
            let cell = tableView.dequeueReusableCell(withIdentifier: "toolsCell", for: indexPath) as! FriendInformationToolsCell
            let tool = tools[indexPath.row]
            let image = toolsImages[indexPath.row]
            cell.toolName.text = tool
            cell.toolImage.image = UIImage(named: image)
            return cell
        }
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        let tool = tools[indexPath.row]
        if tool == "Send Message" {
            navigationController?.popViewController(animated: true)
        }else if tool == "Shared Media" {
            let sharedMediaVC = SharedMediaVC()
            sharedMediaVC.friend = friend
            show(sharedMediaVC, sender: self)
        }else{
            let controller = MapsVC()
            show(controller, sender: self)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
