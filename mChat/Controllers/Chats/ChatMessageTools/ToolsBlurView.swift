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
    
    var menu: ToolsMenu!
    
    func handleViewDismiss(isDeleted: Bool? = nil, isReply: Bool? = nil, isForward: Bool? = nil){
        if isDeleted == nil {
            menu.mView.removeFromSuperview()
            menu.tView.removeFromSuperview()
            menu.chatView.view.addSubview(menu.tView)
            menu.chatView.view.addSubview(menu.mView)
            menu.chatView.view.insertSubview(menu.chatView.messageContainer, aboveSubview: menu.mView)
        }
        let width = menu.backgroundFrame.size.width
        let height = menu.backgroundFrame.size.height
        let xValue = menu.backgroundFrame.origin.x
        let yValue = menu.cellFrame.origin.y
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            if isDeleted == nil {
                self.menu.mView.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
                self.menu.tView.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
                self.menu.tView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                self.menu.tView.layoutIfNeeded()
                self.menu.tView.layer.add(self.animateToolsView(fV: 1, tV: 0), forKey: "Changes Opacity")
            }
            self.menu.sView.removeFromSuperview()
            self.removeFromSuperview()
        }) { (true) in
            self.menu.chatView.collectionView.isUserInteractionEnabled = true
            self.menu.chatView.view.insertSubview(self.menu.chatView.messageContainer, aboveSubview: self.menu.chatView.collectionView)
            self.menu.cell.isHidden = false
            self.menu.mView.removeFromSuperview()
            self.menu.tView.removeFromSuperview()
            if isReply != nil{
                self.menu.chatView.responseButtonPressed(self.menu.message)
            }
            if isForward != nil {
                self.menu.chatView.forwardButtonPressed(self.menu.message)
            }
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
