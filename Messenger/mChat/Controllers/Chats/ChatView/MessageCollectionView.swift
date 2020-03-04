//
//  MessageCollectionView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/31/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class MessageCollectionView: UICollectionView, UIGestureRecognizerDelegate{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var chatVC: ChatVC!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(collectionViewLayout layout: UICollectionViewLayout, chatVC: ChatVC) {
        super.init(frame: .zero, collectionViewLayout: layout)
        self.chatVC = chatVC
        setupCollectionView()
        setuplongPress()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupCollectionView(){
        chatVC.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        delegate = chatVC
        dataSource = chatVC
        backgroundColor = .clear
        contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0)
        register(ChatCell.self, forCellWithReuseIdentifier: "ChatCell")
        let constraints = [
            topAnchor.constraint(equalTo: chatVC.view.topAnchor),
            bottomAnchor.constraint(equalTo: chatVC.messageContainer.topAnchor),
            leadingAnchor.constraint(equalTo: chatVC.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: chatVC.view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setuplongPress(){
        let gesture = UILongPressGestureRecognizer(target: chatVC, action: #selector(chatVC.handleLongPressGesture(longPress:)))
        gesture.delegate = self
        gesture.delaysTouchesBegan = true
        gesture.minimumPressDuration = 0.5
        addGestureRecognizer(gesture)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
