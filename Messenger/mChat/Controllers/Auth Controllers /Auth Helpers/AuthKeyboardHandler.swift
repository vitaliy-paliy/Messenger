//
//  AuthKeyboardHandler.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/27/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class AuthKeyboardHandler {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var view: UIView!
    var keyboardIsShown = false
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: NOTIF CENTER
    
    func notificationCenterHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardOnTap()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: WILL SHOW METHOD
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height, let duration = kDuration else { return }
        if !keyboardIsShown {
            view.frame.origin.y -= height
        }
        keyboardIsShown = true
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: WILL HIDE METHOD
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height, let duration = kDuration else { return }
        view.frame.origin.y += height
        keyboardIsShown = false
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: HIDE KEYBOARD ON TAP
    
    private func hideKeyboardOnTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func hideKeyboard(){
        view.endEditing(true)
        keyboardIsShown = false
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
