//
//  SharedMediaCell.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/2/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class SharedMediaCell: UICollectionViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var sharedMediaVC = SharedMediaVC()
    var imageView = UIImageView()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupImageView(){
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTappedHandler(tap:)))
        imageView.addGestureRecognizer(tap)
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func imageTappedHandler(tap: UITapGestureRecognizer){
        let imageView = tap.view as? UIImageView
        sharedMediaVC.zoomImageHandler(image: imageView!)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
