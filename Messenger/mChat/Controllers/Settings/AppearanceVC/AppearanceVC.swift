//
//  AppearanceVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/9/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class AppearanceVC: UIViewController {
    
    var tableView = UITableView()
    var appearanceSettings = ["Incoming Color", "Outcoming Color","Chat Background"]
    var chatBubblesAppearence = ChatBubblesAppearanceCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Appearance"
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.register(ChatAppearanceCell.self, forCellReuseIdentifier: "ChatAppearanceCell")
        tableView.register(SetupChatAppearanceCell.self, forCellReuseIdentifier: "SetupChatAppearanceCell")
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension AppearanceVC: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        if section == 0 {
            let textLabel = UILabel()
            textLabel.text = "CHAT VIEW"
            textLabel.textColor = .gray
            textLabel.font = UIFont(name: "Helvetica Neue", size: 14)
            textLabel.numberOfLines = 0
            headerView.addSubview(textLabel)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                textLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
                textLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return returnHeaderHeight(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnSectionNumOfCells(section)
    }
    
    func returnSectionNumOfCells(_ section: Int) -> Int {
        if section == 1 {
            return 3
        }else{
            return 1
        }
    }
    
    func returnHeaderHeight(_ section: Int) -> CGFloat {
        if section == 0 {
            return 45
        }else{
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            tableView.rowHeight = 160
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatAppearanceCell") as! ChatAppearanceCell
            cell.appearanceVC = self
            return cell
        }else if indexPath.section == 1{
            tableView.rowHeight = 100
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetupChatAppearanceCell") as! SetupChatAppearanceCell
            let item = appearanceSettings[indexPath.row]
            cell.selectionStyle = .none
            cell.appearenceVC = self
            cell.item = item
            return cell
        }else{
            tableView.rowHeight = 44
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetupChatAppearanceCell") as! SetupChatAppearanceCell
            cell.item = "Restore to Default Views"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }
        chatBubblesAppearence.setupStandardBackground()
    }
    
}
