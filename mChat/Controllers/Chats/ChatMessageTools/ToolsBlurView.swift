//
//  ToolsBlurView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ToolsBlurView: UIVisualEffectView {
    
    var cell: ChatCell!
    var message: Messages!
    var mView: UIView!
    var tView: UIView!
    var backgroundFrame: CGRect!
    var cellFrame: CGRect!
    var sView: UIScrollView!
    var timer = Timer()
    var chatView: ChatVC!
    
    func handleViewDismiss(isDeleted: Bool){
        if !isDeleted {
            mView.removeFromSuperview()
            tView.removeFromSuperview()
            self.chatView.view.addSubview(self.tView)
            self.chatView.view.addSubview(self.mView)
        }
        let width = backgroundFrame.size.width
        let height = backgroundFrame.size.height
        let xValue = backgroundFrame.origin.x
        let yValue = cellFrame.origin.y
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            if !isDeleted {
                self.mView.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
                self.tView.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
                self.tView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                self.tView.layoutIfNeeded()
                self.tView.layer.add(self.animateToolsView(fV: 1, tV: 0), forKey: "Changes Opacity")
            }
            self.sView.removeFromSuperview()
            self.removeFromSuperview()
        }) { (true) in
//            UIView.animate(withDuration: 0.3) { self.chatView.messageContainer.alpha = 1 }
            self.cell.isHidden = false
            self.mView.removeFromSuperview()
            self.tView.removeFromSuperview()
        }
    }
    
    func animateToolsView(fV: CGFloat, tV: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = fV
        animation.toValue = tV
        animation.duration = 0.25
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
}
