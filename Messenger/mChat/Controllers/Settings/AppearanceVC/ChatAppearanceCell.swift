//
//  ChatAppearanceCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/10/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class ChatAppearanceCell: UITableViewCell{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var collectionView: UICollectionView!
    
    var appearanceVC: AppearanceVC! {
        didSet {
            setupCollectionView()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChatBubblesAppearanceCell.self, forCellWithReuseIdentifier: "ChatBubblesAppearanceCell")
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

extension ChatAppearanceCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatBubblesAppearanceCell", for: indexPath) as! ChatBubblesAppearanceCell
        cell.appearanceVC = appearanceVC
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
