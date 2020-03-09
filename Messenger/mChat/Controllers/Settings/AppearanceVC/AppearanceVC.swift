//
//  AppearanceVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/9/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import CoreData

class AppearanceVC: UIViewController{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // Here user can change the appearance of a chat.
    
    let tableView = UITableView()
    var chatBubblesAppearence = ChatBubblesAppearanceCell()
    var selectedView: String!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Appearance"
        view.backgroundColor = .white
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
        tableView.backgroundColor = .clear
        tableView.register(ChatAppearanceCell.self, forCellReuseIdentifier: "ChatAppearanceCell")
        tableView.register(ChatColorPickerCell.self, forCellReuseIdentifier: "ChatColorPickerCell")
        tableView.register(SelectViewColorCell.self, forCellReuseIdentifier: "SelectViewColorCell")
        tableView.register(RestoreToDefaultColorsCell.self, forCellReuseIdentifier: "RestoreToDefaultColorsCell")
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func resetColors() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppColors")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try context.execute(batchDeleteRequest)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

extension AppearanceVC: UITableViewDelegate, UITableViewDataSource {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if section == 0 {
            headerView.backgroundColor = UIColor.systemBackground
            let textLabel = UILabel()
            textLabel.textColor = .gray
            textLabel.font = UIFont(name: "Helvetica Neue", size: 14)
            textLabel.numberOfLines = 0
            headerView.addSubview(textLabel)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.text = "CHAT VIEW"
            let constraints = [
                textLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
                textLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
            ]
            NSLayoutConstraint.activate(constraints)
        }else if section > 1{
            headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        }
        return headerView
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return returnHeaderHeight(section)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnSectionNumOfCells(section)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func returnSectionNumOfCells(_ section: Int) -> Int {
        return 1
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func returnHeaderHeight(_ section: Int) -> CGFloat {
        if section == 0 {
            return 45
        }else{
            return 5
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            tableView.rowHeight = 160
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatAppearanceCell") as! ChatAppearanceCell
            cell.appearanceVC = self
            return cell
        }else if indexPath.section == 1{
            tableView.rowHeight = 300
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatColorPickerCell") as! ChatColorPickerCell
            cell.controller = self
            return cell
        }else if indexPath.section == 2{
            tableView.rowHeight = 100
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectViewColorCell") as! SelectViewColorCell
            cell.controller = self
            return cell
        }else{
            tableView.rowHeight = 44
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestoreToDefaultColorsCell") as! RestoreToDefaultColorsCell
            return cell
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            tableView.deselectRow(at: indexPath, animated: true)
            chatBubblesAppearence.setupStandardColors()
        }else if indexPath.section == 3 {
            tableView.deselectRow(at: indexPath, animated: true)
            ThemeColors.selectedIncomingColor = UIColor.white
            ThemeColors.selectedOutcomingColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
            ThemeColors.selectedBackgroundColor = UIColor(white: 0.95, alpha: 1)
            ThemeColors.selectedIncomingTextColor = UIColor.black
            ThemeColors.selectedOutcomingTextColor = UIColor.white
            resetColors()
            tableView.reloadData()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
