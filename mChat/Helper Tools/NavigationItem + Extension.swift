//
//  NavigationItem + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/10/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    func setNavTitles(navTitle: String, navSubtitle: String){
        
        let title = UILabel()
        let subtitle = UILabel()
        
        title.text = navTitle
        title.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        
        subtitle.text = navSubtitle
        subtitle.font = UIFont(name: "Helvetica Neue", size: 14)
        subtitle.textColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [title, subtitle])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .center
        
        let width = max(title.frame.size.width, subtitle.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 25)
        
        title.sizeToFit()
        subtitle.sizeToFit()
        
        self.titleView = stackView
        
    }
    
}
