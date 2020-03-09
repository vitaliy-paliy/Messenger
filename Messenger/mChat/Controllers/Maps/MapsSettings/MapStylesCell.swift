//
//  MapStylesCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/11/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import CoreData

class MapStylesCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var collectionView: UICollectionView!
    
    var mapStyles = [MapStyles]()
    
    let mapStyleImages = ["Streets Style","Light Style","Dark Style","Satellite Style","Satellite Light Style","Satellite Dark Style"]
    
    let mapUrls = [
        "Streets Style":"mapbox://styles/mapbox/streets-v11",
        "Light Style":"mapbox://styles/mapbox/light-v10",
        "Dark Style":"mapbox://styles/mapbox/dark-v10",
        "Satellite Style":"mapbox://styles/mapbox/satellite-v9",
        "Satellite Light Style":"mapbox://styles/mapbox/navigation-preview-day-v4",
        "Satellite Dark Style":"mapbox://styles/mapbox/navigation-preview-night-v4"
    ]
    
    var mapsVC: MapsVC?
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupData()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupData(){
        for style in mapStyleImages {
            let mapStyle = MapStyles(name: style,nil)
            mapStyles.append(mapStyle)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupCollectionView(){
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
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mapStyles.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StylesCollectionViewCell", for: indexPath) as! StylesCollectionViewCell
        let style = mapStyles[indexPath.row]      
        if mapUrls[style.name] == ThemeColors.selectedMapUrl {
            cell.layer.borderColor = ThemeColors.mainColor.cgColor
            cell.layer.borderWidth = 2
        }else{
            cell.layer.borderWidth = 0
        }
        cell.imageView.image = UIImage(named: style.name)
        cell.nameLabel.text = style.name
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for s in 0..<mapStyles.count {
            mapStyles[s].selected = nil
        }
        mapStyles[indexPath.row].selected = mapStyles[indexPath.row].name
        ThemeColors.selectedMapUrl = mapUrls[mapStyles[indexPath.row].name] ?? "mapbox://styles/mapbox/streets-v11"
        updateColorsHandler(mapUrls[mapStyles[indexPath.row].name] ?? "mapbox://styles/mapbox/streets-v11")
        mapsVC?.updateMapStyle()
        collectionView.reloadData()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func updateColorsHandler(_ mapUrl: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "AppColors", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        newEntity.setValue(mapUrl, forKey: "selectedMapUrl")
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
