//
//  ColorPickerCollectionViewCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/11/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class ColorPickerCollectionViewCell: UICollectionViewCell {
       
    var pickerImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 25
        layer.borderWidth = 5
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPickerImage() {
        addSubview(pickerImage)
        pickerImage.translatesAutoresizingMaskIntoConstraints = false
        pickerImage.contentMode = .scaleAspectFill
        pickerImage.image = UIImage(named: "art_pallete")
        let constraints = [
            pickerImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerImage.topAnchor.constraint(equalTo: topAnchor),
            pickerImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func removePickerImage() {
        pickerImage.removeFromSuperview()
    }
    
}
