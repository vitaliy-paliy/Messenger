//
//  ToolsBlurView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ToolsBlurView: UIVisualEffectView {
    
    var cell: ChatCell!
    var message: Messages!
    var mView: UIView!
    var tView: UIView!
    var backgroundFrame: CGRect!
    var cellFrame: CGRect!
    var sView: UIScrollView!
    var timer = Timer()
    var chatView: UIView!
    var chatCollection: UICollectionView!
    
    func handleViewDismiss(){
        mView.removeFromSuperview()
        tView.removeFromSuperview()
        chatView.addSubview(tView)
        chatView.addSubview(mView)
        let width = backgroundFrame.size.width
        let height = backgroundFrame.size.height
        let xValue = backgroundFrame.origin.x
        let yValue = cellFrame.origin.y
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.mView.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
            self.tView.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
            self.tView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            self.tView.layoutIfNeeded()
            self.tView.layer.add(self.animateToolsView(), forKey: "Changes Opacity")
            self.removeFromSuperview()
            self.sView.removeFromSuperview()
        }) { (true) in
            self.cell.isHidden = false
            self.mView.removeFromSuperview()
            self.tView.removeFromSuperview()
        }
    }
    
    func animateToolsView() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 0.25
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
}
