//
//  ToolsView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ToolsView: UIView{

    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
