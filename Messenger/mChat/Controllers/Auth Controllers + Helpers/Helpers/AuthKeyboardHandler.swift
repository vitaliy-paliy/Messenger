//
//  AuthKeyboardHandler.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/27/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class AuthKeyboardHandler {
    
    var view: UIView!
    var keyboardIsShown = false
    var keyBoardHeight: CGFloat?
    
    func notificationCenterHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardOnTap()
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height, let duration = kDuration else { return }
        if !keyboardIsShown {
            keyBoardHeight = height
            view.frame.origin.y -= keyBoardHeight!
        }
        keyboardIsShown = true
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = keyBoardHeight else { return }
        view.frame.origin.y += height
        keyboardIsShown = false
        guard let duration = kDuration else { return }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideKeyboardOnTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
        keyboardIsShown = false
    }
    
}
