//
//  ColorPickerCollectionViewCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/11/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class ColorPickerCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 25
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
