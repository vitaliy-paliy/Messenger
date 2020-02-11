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
        tableView.register(ChatAppearenceCell.self, forCellReuseIdentifier: "ChatAppearenceCell")
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
            textLabel.text = "CHAT VIEW SAMPLE"
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
        if section == 0 {
            return 1
        }else if section == 1{
            return 4
        }else{
            return 2
        }
    }
    
    func returnHeaderHeight(_ section: Int) -> CGFloat {
        if section == 0 {
            return 45
        }else if section == 1 {
            return 15
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            tableView.rowHeight = 160
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatAppearenceCell") as! ChatAppearenceCell
            return cell
        }
        tableView.rowHeight = 44
        return UITableViewCell()
    }
    
}
