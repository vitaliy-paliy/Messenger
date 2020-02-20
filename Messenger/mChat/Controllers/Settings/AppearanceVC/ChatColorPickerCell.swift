//
//  ChatColorPickerCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/19/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import IGColorPicker

class ChatColorPickerCell: UITableViewCell, ColorPickerViewDelegate {
       
    var colorPicker = ColorPickerView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupColorPicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupColorPicker() {
        addSubview(colorPicker)
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        colorPicker.colors.remove(at: colorPicker.colors.count - 1)
        let constraints = [
            colorPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorPicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorPicker.topAnchor.constraint(equalTo: topAnchor),
            colorPicker.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
}
