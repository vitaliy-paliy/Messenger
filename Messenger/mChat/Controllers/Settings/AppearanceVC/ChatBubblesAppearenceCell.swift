//
//  ChatBubblesAppearanceCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/10/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class ChatBubblesAppearanceCell: UICollectionViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let gradient = UIViewController.init().setupGradientLayer()
    let incomingView = UIView()
    let incomingLabel = UILabel()
    let outcomingView = UIView()
    let outcomingLabel = UILabel()
    
    var appearanceVC: AppearanceVC! {
        didSet {
            appearanceVC.chatBubblesAppearence = self
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        incomingView.backgroundColor = ThemeColors.selectedIncomingColor
        outcomingView.backgroundColor = ThemeColors.selectedOutcomingColor
        backgroundColor = ThemeColors.selectedBackgroundColor
        setupIncomingView()
        setupOutcomingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupStandardColors() {
        gradient.frame = frame
        layer.insertSublayer(gradient, at: 0)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupIncomingView() {
        addSubview(incomingView)
        incomingView.translatesAutoresizingMaskIntoConstraints = false
        incomingView.layer.cornerRadius = 16
        incomingView.layer.masksToBounds = true
        let constraints = [
            incomingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            incomingView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            incomingView.widthAnchor.constraint(equalToConstant: 210),
            incomingView.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
        setupIncomingLabel()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupOutcomingView() {
        addSubview(outcomingView)
        outcomingView.translatesAutoresizingMaskIntoConstraints = false
        outcomingView.layer.cornerRadius = 16
        outcomingView.layer.masksToBounds = true
        let constraints = [
            outcomingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            outcomingView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            outcomingView.widthAnchor.constraint(equalToConstant: 200),
            outcomingView.heightAnchor.constraint(equalToConstant: 75),
        ]
        NSLayoutConstraint.activate(constraints)
        setupOutcomingLabel()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupIncomingLabel() {
        incomingView.addSubview(incomingLabel)
        incomingLabel.translatesAutoresizingMaskIntoConstraints = false
        incomingLabel.text = "Hey, how are you? Nice to see you here!🙂"
        incomingLabel.textColor = ThemeColors.selectedIncomingTextColor
        incomingLabel.numberOfLines = 0
        incomingLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        let constraints = [
            incomingLabel.leadingAnchor.constraint(equalTo: incomingView.leadingAnchor, constant: 12),
            incomingLabel.trailingAnchor.constraint(equalTo: incomingView.trailingAnchor),
            incomingLabel.topAnchor.constraint(equalTo: incomingView.topAnchor, constant: 6),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupOutcomingLabel() {
        outcomingView.addSubview(outcomingLabel)
        outcomingLabel.translatesAutoresizingMaskIntoConstraints = false
        outcomingLabel.text = "Hey! I'm great. Do you want to go to the movies tonight?"
        outcomingLabel.textColor = ThemeColors.selectedOutcomingTextColor
        outcomingLabel.numberOfLines = 0
        outcomingLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        let constraints = [
            outcomingLabel.leadingAnchor.constraint(equalTo: outcomingView.leadingAnchor, constant: 12),
            outcomingLabel.trailingAnchor.constraint(equalTo: outcomingView.trailingAnchor),
            outcomingLabel.topAnchor.constraint(equalTo: outcomingView.topAnchor, constant: 6),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
