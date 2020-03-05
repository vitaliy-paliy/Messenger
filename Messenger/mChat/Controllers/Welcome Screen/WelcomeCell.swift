//
//  WelcomeCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/20/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class WelcomeCell: UICollectionViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var welcomeVC: WelcomeVC!
    var topicImage = UIImageView()
    var topicLabel = UILabel()
    var descriptionLabel = UILabel()
    
    var page: WelcomePage? {
        didSet {
            topicImage.image = UIImage(named: page?.imageName ?? "")
            topicLabel.text = page?.topicText
            descriptionLabel.text = page?.descriptionText
            if page?.topicText == "Start Messaging" {
                topicImage.removeFromSuperview()
                topicLabel.removeFromSuperview()
                descriptionLabel.removeFromSuperview()
            }else{
                setupTopicImage()
                setupTopicLabel()
                setupDescriptionLabel()
            }
        }
    }
        
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTopicImage()
        setupTopicLabel()
        setupDescriptionLabel()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTopicImage() {
        addSubview(topicImage)
        topicImage.translatesAutoresizingMaskIntoConstraints = false
        topicImage.contentMode = .scaleAspectFill
        topicImage.layer.cornerRadius = 75
        topicImage.layer.masksToBounds = true
        let constraints = [
            topicImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            topicImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -(center.y/2)),
            topicImage.widthAnchor.constraint(equalToConstant: 150),
            topicImage.heightAnchor.constraint(equalToConstant: 150),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupTopicLabel() {
        addSubview(topicLabel)
        topicLabel.translatesAutoresizingMaskIntoConstraints  = false
        topicLabel.font = UIFont(name: "Alata", size: 28)
        topicLabel.textAlignment = .center
        let constraints = [
            topicLabel.topAnchor.constraint(equalTo: topicImage.bottomAnchor, constant: 16),
            topicLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "Alata", size: 18)
        let constraints = [
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: topicLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
