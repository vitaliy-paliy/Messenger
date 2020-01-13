//
//  StylesCollectionViewcell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/11/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import LTHRadioButton

class StylesCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var radioButton = LTHRadioButton(diameter: 16, selectedColor: .black, deselectedColor: .lightGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.cornerRadius = 8
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        setupNameLabel()
        setupImageView()
        setupRadioButton()
    }

    func setupImageView(){
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -2)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "AvenirNext-Medium", size: 16)
        let constraints = [
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupRadioButton(){
        addSubview(radioButton)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            radioButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            radioButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 16),
            radioButton.heightAnchor.constraint(equalToConstant: 16)
        ]
        NSLayoutConstraint.activate(constraints)
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

