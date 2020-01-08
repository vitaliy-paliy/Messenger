//
//  SettingsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    var logoutButton = UIButton(type: .system)
    var tableView = UITableView()
    
    var settingsItems = ["Saved Messages", "Appearance", "Maps"]
    var settingsImages = ["folder.fill", "paintbrush.fill","map.fill"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        view.backgroundColor = .white
        setupTableView()
        setupLeftNavButton()
        
    }
    
    func setupLeftNavButton(){
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 18)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func logoutButtonPressed(){
        do{
            Constants.activityObservers(isOnline: false)
            try Auth.auth().signOut()
            let controller = SignInVC()
            view.window?.rootViewController = controller
            view.window?.makeKeyAndVisible()
        }catch{
            showAlert(title: "Error", message: error.localizedDescription)
        }
        
    }
    
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 { return 30 } else { return 0.1 }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 } else { return 3 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            tableView.rowHeight = 100
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            cell.emailLabel.text = CurrentUser.email
            cell.nameLabel.text = CurrentUser.name
            cell.profileImage.loadImage(url: CurrentUser.profileImage)
            return cell
        }else{
            tableView.rowHeight = 45
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
            let item = settingsItems[indexPath.row]
            let itemImg = settingsImages[indexPath.row]
            cell.settingsLabel.text = item
            cell.settingsImage.image = UIImage(systemName: itemImg)
            if item == "Appearance" {
                cell.settingsImage.tintColor = .orange
            }else if item == "Maps"{
                cell.settingsImage.tintColor = .systemGreen
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            print("TODO: Changing password etc.")
        }else{
            let item = settingsItems[indexPath.row]
            if item == "Appearance"{
                print("TODO: Appearance")
            }else if item == "Saved Messages"{
                print("TODO: Saved Messages")
            }else{
                let mapSettings = MapsSettingsVC()
                show(mapSettings, sender: self)
            }
        }
    }
    
    
}
