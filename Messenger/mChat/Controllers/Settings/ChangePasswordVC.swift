//
//  ChangePasswordVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/27/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Lottie

class ChangePasswordVC: UIViewController{
    
    var infoAnimView = AnimationView()
    var infoLabel = UILabel()
    
    var oldPasswordTF = UITextField()
    var newPasswordTF = UITextField()
    var confirmNewPasswordTF = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Change Password"
        setupInfoLabel()
        setupChangeInfoAnim()
        setupTextfields()
        hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupChangeInfoAnim() {
        view.addSubview(infoAnimView)
        infoAnimView.translatesAutoresizingMaskIntoConstraints = false
        infoAnimView.animation = Animation.named("changeInfo_anim")
        infoAnimView.loopMode = .loop
        infoAnimView.play()
        infoAnimView.backgroundBehavior = .pauseAndRestore
        let constraints = [
            infoAnimView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoAnimView.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -16),
            infoAnimView.widthAnchor.constraint(equalToConstant: 250),
            infoAnimView.heightAnchor.constraint(equalToConstant: 250),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupInfoLabel() {
        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.text = "Here you can change your password.\nNOTE: \nA valid password must contain 6 characters."
        infoLabel.textColor = .gray
        infoLabel.font = UIFont.boldSystemFont(ofSize: 14)
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        let constraints = [
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupTextfields() {
        view.addSubview(oldPasswordTF)
        oldPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        oldPasswordTF.borderStyle = .none
        oldPasswordTF.backgroundColor = UIColor(white: 0.95, alpha: 1)
        oldPasswordTF.placeholder = "Old Password"
        oldPasswordTF.layer.cornerRadius = 16
        oldPasswordTF.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: oldPasswordTF.frame.height))
        oldPasswordTF.leftView = paddingView
        oldPasswordTF.leftViewMode = .always
        let constraints = [
            oldPasswordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oldPasswordTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            oldPasswordTF.widthAnchor.constraint(equalToConstant: 250),
            oldPasswordTF.heightAnchor.constraint(equalToConstant: 35)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
}
