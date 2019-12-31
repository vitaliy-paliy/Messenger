//
//  ToolsView + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/31/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

extension ChatVC{
    
    func openToolsMenu(_ indexPath: IndexPath, _ message: Messages, _ selectedCell: ChatCell){
        hideKeyboard()
        collectionView.isUserInteractionEnabled = false
        selectedCell.isHidden = true
        let window = UIApplication.shared.windows[0]
        let cF = collectionView.convert(selectedCell.frame, to: collectionView.superview)
        let bF = collectionView.convert(selectedCell.messageBackground.frame, to: collectionView.superview)
        let width = selectedCell.messageBackground.frame.size.width
        let height = selectedCell.messageBackground.frame.size.height
        toolsScrollView = setupScrollView(height)
        toolsBlurView = setupBlurView()
        window.addSubview(toolsScrollView)
        toolsScrollView.addSubview(toolsBlurView)
        var xValue: CGFloat = bF.origin.x
        if !selectedCell.isIncoming, bF.width < 190 {
            xValue = bF.minX - 150
            let width = bF.width
            if  width < 190, width > 120 { xValue = bF.origin.x - 90 }
        }
        var scrollYValue = cF.maxY + 8
        var messageYValue = cF.origin.y
        let noScroll = toolsScrollView.contentSize.height == view.frame.height
        if !noScroll {
            scrollYValue = height
            messageYValue = toolsScrollView.frame.minY - 8
            toolsScrollView.setContentOffset(CGPoint(x: 0, y: max(toolsScrollView.contentSize.height - toolsScrollView.bounds.size.height, 0) ), animated: true)
        }
        let toolsView = ToolsView(frame: CGRect(x: xValue, y: scrollYValue, width: 200, height: 200))
        toolsScrollView.addSubview(toolsView)
        let _ = ToolsTB(frame: toolsView.frame, style: .plain, tV: toolsView, bV: toolsBlurView, cV: self, sM: message, i: indexPath, cell: selectedCell)
        let msgViewFrame = CGRect(x: bF.origin.x, y: messageYValue, width: width, height: height)
        let messageView = MessageView(frame: msgViewFrame, cell: selectedCell, message: message, friendName: friend.name)
        toolsScrollView.addSubview(messageView)
        toolMessageAppearance(window.frame, toolsView, messageView, noScroll, height)
        let menu = ToolsMenuView(cell: selectedCell, message: message, mView: messageView, tView: toolsView, backgroundFrame: bF, cellFrame: cF, sView: toolsScrollView, chatView: self)
        toolsBlurView.menu = menu
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    

    
    func setupBlurView() -> ToolsBlurView{
        let blurView = ToolsBlurView()
        blurView.effect = UIBlurEffect(style: .dark)
        let size = toolsScrollView.contentSize
        blurView.frame = CGRect(x: 0, y: -400, width: size.width, height: size.height + 1000)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setupExitMenu))
        blurView.addGestureRecognizer(tapGesture)
        return blurView
    }
    
    func setupScrollView(_ height: CGFloat) -> UIScrollView{
        let scrollView = UIScrollView()
        scrollView.frame = view.frame
        var sHeight: CGFloat
        scrollView.backgroundColor = .clear
        if height < view.frame.height - 220 { sHeight = view.frame.height } else { sHeight = height + 230 }
        scrollView.contentSize = CGSize(width: view.frame.width, height: sHeight)
        return scrollView
    }
    
    @objc func setupExitMenu(){
        toolsBlurView.handleViewDismiss()
    }
    
}
