//
//  ToolsMenuView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/31/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ToolsMenuView {
    var cell: ChatCell
    var message: Messages
    var mView: UIView
    var tView: UIView
    var backgroundFrame: CGRect
    var cellFrame: CGRect
    var sView: UIScrollView
    var chatView: ChatVC
    init(cell: ChatCell, message: Messages, mView: UIView, tView: UIView, backgroundFrame: CGRect, cellFrame: CGRect, sView: UIScrollView, chatView: ChatVC) {
        self.cell = cell
        self.message = message
        self.mView = mView
        self.tView = tView
        self.backgroundFrame = backgroundFrame
        self.cellFrame = cellFrame
        self.sView = sView
        self.chatView = chatView
    }
}
