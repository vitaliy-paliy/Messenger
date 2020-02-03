//
//  MapSettingsButton.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/15/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class MapSettingsButton: UIButton {
    
    var mapsVC: MapsVC!
    
    init(mapsVC: MapsVC) {
        super.init(frame: .zero)
        self.mapsVC = mapsVC
        setupSettingsButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSettingsButton(){
        mapsVC.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = .white
        setImage(UIImage(systemName: "gear"), for: .normal)
        tintColor = .white
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        addTarget(mapsVC, action: #selector(mapsVC.openMapsSettings), for: .touchUpInside)
        let constraints = [
            trailingAnchor.constraint(equalTo: mapsVC.view.trailingAnchor, constant: -8),
            topAnchor.constraint(equalTo: mapsVC.view.safeAreaLayoutGuide.topAnchor, constant: 4),
            widthAnchor.constraint(equalToConstant: 45),
            heightAnchor.constraint(equalToConstant: 45),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
