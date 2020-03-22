//
//  MapsSettingsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/8/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

class MapsSettingsVC: UIViewController {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let tableView = UITableView()
    var isMapOpened = false
    var mapsVC: MapsVC?
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        if isMapOpened { setupBackButton() }
        navigationItem.title = "Maps"
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
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
    
    private func setupBackButton(){
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.leftBarButtonItem = button
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func backButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(MapSettingsCell.self, forCellReuseIdentifier: "MapSettingsCell")
        tableView.register(MapStylesCell.self, forCellReuseIdentifier: "MapStylesCell")
        tableView.backgroundColor = .clear
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func changeSwitchValue(_ button: UISwitch){
        refreshIncognitoMode(to: !button.isOn)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func refreshIncognitoMode(to status: Bool){
        let ref = Database.database().reference().child("users").child(CurrentUser.uid)
        let values = ["isMapLocationEnabled": status]
        ref.updateChildValues(values) { (error, reference) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            CurrentUser.isMapLocationEnabled = status
            self.tableView.reloadData()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

extension MapsSettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        if section == 0 {
            let textLabel = UILabel()
            textLabel.text = "If Incognito mode is turned on, your location won't be visible on the map to your friends."
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 45 } else { return 15 }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isMapOpened { return 2 } else { return 3 }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If MapSettingsVC was opened in MapsVC then we should hide the "Open maps" row
        let section = isMapOpened ? indexPath.section + 1 : 1
        if indexPath.section == 0 {
            tableView.rowHeight = 35
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapSettingsCell") as! MapSettingsCell
            cell.selectionStyle = .none
            cell.switchButton.isOn = !(CurrentUser.isMapLocationEnabled ?? false)
            cell.setupSwitch()
            cell.textLabel?.text = "Incognito mode"
            return cell
        }else if indexPath.section == section {
            if isMapOpened { return UITableViewCell() }
            tableView.rowHeight = 35
            let cell = UITableViewCell()
            cell.textLabel?.text = "Open maps"
            return cell
        }else{
            tableView.rowHeight = 250
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapStylesCell") as! MapStylesCell
            cell.selectionStyle = .default
            cell.mapsVC = mapsVC
            return cell
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, !isMapOpened else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = MapsVC()
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
