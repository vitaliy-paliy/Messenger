//
//  CurrentUserVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/25/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class CurrentUserVC: UIViewController {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let tableView = UITableView()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView() {
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

extension CurrentUserVC: UITableViewDelegate, UITableViewDataSource {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        if section == 0 {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = "Account Settings"
            label.textColor = .gray
            headerView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
                label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
                label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            ]
            NSLayoutConstraint.activate(constraints)
        }
        return headerView
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 32 } else { return 15 }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.accessoryType = .disclosureIndicator
        if indexPath.section == 0{
            cell.textLabel?.text = "Change Password"
        }else{
            cell.textLabel?.text = "Change Email"
        }
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            let controller = ChangePasswordVC()
            show(controller, sender: nil)
        }else{
            let controller = ChangeEmailVC()
            show(controller, sender: nil)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
