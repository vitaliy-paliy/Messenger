//
//  SetupChatAppearanceCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/11/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

struct AvailableColors {
    var selectedIncomingColor: UIColor!
    var selectedOutcomingColor: UIColor!
    var selectedBackgroundColor: UIColor!
}

class SetupChatAppearanceCell: UITableViewCell {

    var collectionView: UICollectionView!
    let cellLabel = UILabel()
    var appearenceVC: AppearanceVC!
    var colorsCollection = AvailableColors()
    var colors = [
        .black,
        UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1),
        UIColor(displayP3Red: 102/255, green: 190/255, blue: 200/255, alpha: 1),
        UIColor(displayP3Red: 125/255, green: 200/255, blue: 85/255, alpha: 1),
        UIColor(displayP3Red: 90/255, green: 190/255, blue: 125/255, alpha: 1),
        UIColor(displayP3Red: 86/255, green: 130/255, blue: 130/255, alpha: 1),
        UIColor(displayP3Red: 120/255, green: 54/255, blue: 220/255, alpha: 1),
        UIColor(displayP3Red: 127/255, green: 140/255, blue: 218/255, alpha: 1),
        UIColor(displayP3Red: 240/255, green: 136/255, blue: 171/255, alpha: 1),
        UIColor(displayP3Red: 240/255, green: 131/255, blue: 64/255, alpha: 1),
        UIColor(displayP3Red: 232/255, green: 78/255, blue: 84/255, alpha: 1)
    ]
    
    var item: String! {
        didSet {
            if item == "Restore to Default Views" {
                setupRestoreViews()
                return
            }
            setupLabel(item)
            setupCollectionView()
        }
    }
    
    private func setupLabel(_ text: String) {
        addSubview(cellLabel)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.text = text
        cellLabel.textColor = .gray
        cellLabel.font = UIFont.boldSystemFont(ofSize: 12)
        let constraints = [
            cellLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cellLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupCollectionView() {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layer)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorPickerCollectionViewCell.self, forCellWithReuseIdentifier: "ColorPickerCollectionViewCell")
        collectionView.backgroundColor = .clear
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: cellLabel.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupRestoreViews() {
        let label = UILabel()
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Restore to default settings"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 16)
        let constraints = [
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
}

extension SetupChatAppearanceCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorPickerCollectionViewCell", for: indexPath) as! ColorPickerCollectionViewCell
        let color = colors[indexPath.row]
        if color == .black {
            cell.setupPickerImage()
            cell.backgroundColor = .white
        }else{
            cell.backgroundColor = color
            cell.removePickerImage()
        }
        if colorsCollection.selectedIncomingColor != nil, colorsCollection.selectedIncomingColor == color {
            cell.layer.borderColor = AppColors.mainColor.cgColor
            return cell
        }else if colorsCollection.selectedOutcomingColor != nil, colorsCollection.selectedOutcomingColor == color {
            cell.layer.borderColor = AppColors.mainColor.cgColor
            return cell
        }else if colorsCollection.selectedBackgroundColor != nil, colorsCollection.selectedBackgroundColor == color {
            cell.layer.borderColor = AppColors.mainColor.cgColor
            return cell
        }
        cell.layer.borderColor = UIColor(white: 0.95, alpha: 0.3).cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorPickerCollectionViewCell
        if cell.backgroundColor == .white {
            print("Do something")
            return
        }
        if cellLabel.text == "Incoming Color" {
            colorsCollection.selectedIncomingColor = cell.backgroundColor ?? UIColor()
            appearenceVC.chatBubblesAppearence.incomingView.backgroundColor = colorsCollection.selectedIncomingColor
        }else if cellLabel.text == "Outcoming Color" {
            colorsCollection.selectedOutcomingColor = cell.backgroundColor ?? UIColor()
            appearenceVC.chatBubblesAppearence.outcomingView.backgroundColor = colorsCollection.selectedOutcomingColor
        }else {
            appearenceVC.chatBubblesAppearence.gradient.removeFromSuperlayer()
            colorsCollection.selectedBackgroundColor = cell.backgroundColor ?? UIColor()
            appearenceVC.chatBubblesAppearence.backgroundColor = colorsCollection.selectedBackgroundColor
        }
        collectionView.reloadData()
    }
    
}

