//
//  SetupChatAppearenceCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/11/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class SetupChatAppearenceCell: UITableViewCell {

    var collectionView: UICollectionView!
    let cellLabel = UILabel()
    
    var colors: [UIColor] = [
        UIColor(displayP3Red: 71/255, green: 171/255, blue: 232/255, alpha: 1),
        UIColor(displayP3Red: 102/255, green: 190/255, blue: 200/255, alpha: 1),
        UIColor(displayP3Red: 125/255, green: 200/255, blue: 85/255, alpha: 1),
        UIColor(displayP3Red: 90/255, green: 190/255, blue: 125/255, alpha: 1),
        UIColor(displayP3Red: 86/255, green: 130/255, blue: 130/255, alpha: 1),
        UIColor(displayP3Red: 127/255, green: 140/255, blue: 218/255, alpha: 1),
        UIColor(displayP3Red: 120/255, green: 54/255, blue: 220/255, alpha: 1),
        UIColor(displayP3Red: 240/255, green: 136/255, blue: 171/255, alpha: 1),
        UIColor(displayP3Red: 240/255, green: 131/255, blue: 64/255, alpha: 1),
        UIColor(displayP3Red: 232/255, green: 78/255, blue: 84/255, alpha: 1),
    ]
    
    var item: String! {
        didSet {
            setupLabel(item)
            setupCollectionView()
            if item == "IncomingColor" {
                print("gi")
            }else{
                print("mo")
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
}

extension SetupChatAppearenceCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorPickerCollectionViewCell", for: indexPath) as! ColorPickerCollectionViewCell
        let color = colors[indexPath.row]
        cell.backgroundColor = color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("hi")
    }
    
}

