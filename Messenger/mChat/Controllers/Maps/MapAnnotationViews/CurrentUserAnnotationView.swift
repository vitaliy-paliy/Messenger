//
//  CurrentUserAnnotationView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/10/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Mapbox

class CurrentUserAnnotationView: MGLUserLocationAnnotationView {

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let size: CGFloat = 32
    let imageLayer = CALayer()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func update() {
        if frame.isNull {
            frame = CGRect(x: 0, y: 0 , width: size, height: size)
            return setNeedsLayout()
        }
        imageLayer.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        let imageView = UIImageView()
        imageView.loadImage(url: CurrentUser.profileImage)
        imageLayer.contents = imageView.image?.cgImage
        imageLayer.cornerRadius = imageLayer.frame.size.width/2
        imageLayer.masksToBounds = true
        imageLayer.borderWidth = 2
        imageLayer.borderColor = UIColor.white.cgColor
        layer.addSublayer(imageLayer)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
