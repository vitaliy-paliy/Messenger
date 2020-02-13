//
//  ChatBubblesAppearenceCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/10/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class ChatBubblesAppearenceCell: UICollectionViewCell {
    
    let incomingView = UIView()
    let incomingLabel = UILabel()
    let outcomingView = UIView()
    let outcomingLabel = UILabel()
    
    var appearenceVC: AppearanceVC! {
        didSet {
            appearenceVC.chatBubblesAppearence = self
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        setupIncomingView()
        setupOutcomingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupIncomingView() {
        addSubview(incomingView)
        incomingView.translatesAutoresizingMaskIntoConstraints = false
        incomingView.layer.cornerRadius = 16
        incomingView.layer.masksToBounds = true
        incomingView.backgroundColor = .white
        let constraints = [
            incomingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            incomingView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            incomingView.widthAnchor.constraint(equalToConstant: 210),
            incomingView.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
        setupIncomingLabel()
    }
    
    private func setupOutcomingView() {
        addSubview(outcomingView)
        outcomingView.translatesAutoresizingMaskIntoConstraints = false
        outcomingView.layer.cornerRadius = 16
        outcomingView.layer.masksToBounds = true
        outcomingView.backgroundColor = UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1)
        let constraints = [
            outcomingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            outcomingView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            outcomingView.widthAnchor.constraint(equalToConstant: 200),
            outcomingView.heightAnchor.constraint(equalToConstant: 75),
        ]
        NSLayoutConstraint.activate(constraints)
        setupOutcomingLabel()
    }
    
    private func setupIncomingLabel() {
        incomingView.addSubview(incomingLabel)
        incomingLabel.translatesAutoresizingMaskIntoConstraints = false
        incomingLabel.text = "Hey, how are you? Nice to see you here!🙂"
        incomingLabel.textColor = .black
        incomingLabel.numberOfLines = 0
        incomingLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        let constraints = [
            incomingLabel.leadingAnchor.constraint(equalTo: incomingView.leadingAnchor, constant: 12),
            incomingLabel.trailingAnchor.constraint(equalTo: incomingView.trailingAnchor),
            incomingLabel.topAnchor.constraint(equalTo: incomingView.topAnchor, constant: 6),
        ]
        NSLayoutConstraint.activate(constraints)
    }
        
    private func setupOutcomingLabel() {
        outcomingView.addSubview(outcomingLabel)
        outcomingLabel.translatesAutoresizingMaskIntoConstraints = false
        outcomingLabel.text = "Hey! I'm great. Do you want to go to the movies tonight?"
        outcomingLabel.textColor = .white
        outcomingLabel.numberOfLines = 0
        outcomingLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        let constraints = [
            outcomingLabel.leadingAnchor.constraint(equalTo: outcomingView.leadingAnchor, constant: 12),
            outcomingLabel.trailingAnchor.constraint(equalTo: outcomingView.trailingAnchor),
            outcomingLabel.topAnchor.constraint(equalTo: outcomingView.topAnchor, constant: 6),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
