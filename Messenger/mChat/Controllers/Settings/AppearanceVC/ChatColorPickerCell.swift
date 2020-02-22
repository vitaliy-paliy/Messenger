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
    var controller: AppearanceVC!
    
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
        colorPicker.colors.append(.white)
        colorPicker.backgroundColor = UIColor(white: 0.95, alpha: 1)
        colorPicker.delegate = self
        let constraints = [
            colorPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorPicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorPicker.topAnchor.constraint(equalTo: topAnchor),
            colorPicker.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
        updateAppColors(colorPickerView.colors[indexPath.row])
    }
        
    func updateAppColors(_ color: UIColor) {
        guard controller.selectedView != nil else { return }
        if controller.selectedView == "Chat Incoming Color" {
            AppColors.selectedIncomingColor = color
            controller.chatBubblesAppearence.incomingView.backgroundColor = color
        }else if controller.selectedView == "Chat Outcoming Color"{
            AppColors.selectedOutcomingColor = color
            controller.chatBubblesAppearence.outcomingView.backgroundColor = color
        }else if controller.selectedView == "Chat Background Color" {
            AppColors.selectedBackgroundColor = color
            controller.chatBubblesAppearence.backgroundColor = color
            controller.chatBubblesAppearence.gradient.removeFromSuperlayer()
        }else if controller.selectedView == "Text Incoming Color" {
            AppColors.selectedIncomingTextColor = color
            controller.chatBubblesAppearence.incomingLabel.textColor = color
        }else if controller.selectedView == "Text Outcoming Color" {
            AppColors.selectedOutcomingTextColor = color
            controller.chatBubblesAppearence.outcomingLabel.textColor = color
        }
    }
    
    
}
