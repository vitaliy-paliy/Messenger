//
//  SelectViewColorCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/19/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class SelectViewColorCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var collectionView: UICollectionView!
    let colorViews = ["Chat Incoming Color", "Chat Outcoming Color", "Chat Background Color", "Text Incoming Color", "Text Outcoming Color"]
    var controller: AppearanceVC!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.register(ChatViewColorPickerCell.self, forCellWithReuseIdentifier: "ChatViewColorPickerCell")
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2.5, height: frame.height/2)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorViews.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatViewColorPickerCell", for: indexPath) as! ChatViewColorPickerCell
        let colorName = colorViews[indexPath.row]
        if controller.selectedView != nil, controller.selectedView == colorName {
            cell.layer.borderColor = ThemeColors.mainColor.cgColor
            cell.layer.borderWidth = 3
        }else{
            cell.layer.borderWidth = 0
        }
        cell.viewLabel.text = colorName
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 16
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 5
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorName = colorViews[indexPath.row]
        controller.selectedView = colorName
        collectionView.reloadData()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
