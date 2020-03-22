//
//  ContactsTableView + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/19/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

extension ContactsVC: UITableViewDataSource, UITableViewDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Friends.list.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell") as! ContactsCell
        cell.selectionStyle = .none
        let friend = Friends.list[indexPath.row]
        cell.profileImage.loadImage(url: friend.profileImage ?? "")
        cell.friendName.text = friend.name
        cell.friendEmail.text = friend.email
        cell.isOnlineView.isHidden = !(friend.isOnline ?? false)
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = Friends.list[indexPath.row]
        if let cellFrame = tableView.cellForRow(at: indexPath)?.frame, let cell = tableView.cellForRow(at: indexPath){
            let convertedFrame = tableView.convert(cellFrame, to: tableView.superview)
            setupFriendInfoMenuView(cell as! ContactsCell, cellFrame: convertedFrame, friend: friend)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
