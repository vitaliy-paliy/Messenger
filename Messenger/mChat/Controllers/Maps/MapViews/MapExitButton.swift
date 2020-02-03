//
//  MapExitButton.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/15/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class MapExitButton: UIButton {
    
    var mapsVC: MapsVC!
    
    init(mapsVC: MapsVC) {
        super.init(frame: .zero)
        self.mapsVC = mapsVC
        setupExitButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupExitButton(){
        mapsVC.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        setImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        tintColor = .white
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        addTarget(mapsVC, action: #selector(mapsVC.exitButtonPressed), for: .touchUpInside)
        let constraints = [
            leadingAnchor.constraint(equalTo: mapsVC.view.leadingAnchor, constant: 8),
            topAnchor.constraint(equalTo: mapsVC.view.safeAreaLayoutGuide.topAnchor, constant: 4),
            widthAnchor.constraint(equalToConstant: 45),
            heightAnchor.constraint(equalToConstant: 45),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
