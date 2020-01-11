//
//  UserCalloutView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/10/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Mapbox

class UserCalloutView: UIView, MGLCalloutView {
    
    var representedObject: MGLAnnotation
    
    var leftAccessoryView = UIView()
    
    var rightAccessoryView = UIView()
    
    var delegate: MGLCalloutViewDelegate?
    
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {
        //
    }
    
    func dismissCallout(animated: Bool) {
        //
    }
        
    required init(annotation: AnnotationPin) {
        self.representedObject = annotation
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.width * 0.75, height: 120.0)))
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        
    }
    
}
