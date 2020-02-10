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
        view.backgroundColor = .red
        navigationController?.navigationBar.tintColor = .black
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
            textLabel.text = "THIS IS TEST"
            textLabel.textColor = .gray
            textLabel.font = UIFont(name: "Helvetica Neue", size: 14)
            textLabel.numberOfLines = 0
            headerView.addSubview(textLabel)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                textLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
                textLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
                textLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 45 } else { return 15 }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
