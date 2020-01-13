//
//  MapStylesCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/11/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

struct MapStyles {
    var name: String
    var selected: String?
    init(name: String, _ selected: String?) {
        self.name = name
        self.selected = selected
    }
}

class MapStylesCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    
    var mapStyles = [MapStyles]()
    
    var mapStyleImages = ["Streets Style","Light Style","Dark Style","Satellite Style","Satellite Light Style","Satellite Dark Style"]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupData()
        setupCollectionView()
    }
    
    func setupData(){
        for style in mapStyleImages {
            let mapStyle = MapStyles(name: style,nil)
            mapStyles.append(mapStyle)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        let size = bounds.width/2
        layout.itemSize =  CGSize(width: size, height: 240)
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        collectionView.register(StylesCollectionViewCell.self, forCellWithReuseIdentifier: "StylesCollectionViewCell")
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mapStyles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StylesCollectionViewCell", for: indexPath) as! StylesCollectionViewCell
        let style = mapStyles[indexPath.row]
        
        if style.selected != nil {
            cell.radioButton.select()
        }else{
            cell.radioButton.deselect()
        }
        cell.imageView.image = UIImage(named: style.name)
        cell.nameLabel.text = style.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for s in 0..<mapStyles.count {
            mapStyles[s].selected = nil
        }
        mapStyles[indexPath.row].selected = mapStyles[indexPath.row].name
        collectionView.reloadData()
    }
    
}
