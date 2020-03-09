//
//  ChatColorPickerCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/19/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import IGColorPicker
import CoreData

class ChatColorPickerCell: UITableViewCell, ColorPickerViewDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let colorPicker = ColorPickerView()
    var controller: AppearanceVC!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupColorPicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupColorPicker() {
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
        updateAppColors(colorPickerView.colors[indexPath.row])
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func updateAppColors(_ color: UIColor) {
        guard controller.selectedView != nil else { return }
        if controller.selectedView == "Chat Incoming Color" {
            ThemeColors.selectedIncomingColor = color
            controller.chatBubblesAppearence.incomingView.backgroundColor = color
            updateColorsHandler(color, "selectedIncomingColor")
        }else if controller.selectedView == "Chat Outcoming Color"{
            ThemeColors.selectedOutcomingColor = color
            controller.chatBubblesAppearence.outcomingView.backgroundColor = color
            updateColorsHandler(color, "selectedOutcomingColor")
        }else if controller.selectedView == "Chat Background Color" {
            ThemeColors.selectedBackgroundColor = color
            controller.chatBubblesAppearence.backgroundColor = color
            controller.chatBubblesAppearence.gradient.removeFromSuperlayer()
            updateColorsHandler(color, "selectedBackgroundColor")
        }else if controller.selectedView == "Text Incoming Color" {
            ThemeColors.selectedIncomingTextColor = color
            controller.chatBubblesAppearence.incomingLabel.textColor = color
            updateColorsHandler(color, "selectedIncomingTextColor")
        }else if controller.selectedView == "Text Outcoming Color" {
            ThemeColors.selectedOutcomingTextColor = color
            controller.chatBubblesAppearence.outcomingLabel.textColor = color
            updateColorsHandler(color, "selectedOutcomingTextColor")
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func updateColorsHandler(_ selectedColor: UIColor, _ key: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "AppColors", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        newEntity.setValue(selectedColor, forKey: key)
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
