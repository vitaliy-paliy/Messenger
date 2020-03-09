//
//  CurrentUserNetworking.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/28/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

class CurrentUserNetworking {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var changePasswordVC: ChangePasswordVC!
    var changeEmailVC: ChangeEmailVC!
    let networkingLoadingIndicator = NetworkingLoadingIndicator()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func changePassword(_ oldCredentials: AuthCredential) {
        networkingLoadingIndicator.startLoadingAnimation()
        Auth.auth().currentUser?.reauthenticate(with: oldCredentials, completion: { (authResults, error) in
            if let error = error{
                self.changePasswordVC.showAlert(title: "Error", message: error.localizedDescription)
                self.networkingLoadingIndicator.endLoadingAnimation()
            }else{
                self.changePasswordHandler()
            }
        })
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func changePasswordHandler(){
        guard let newPassword = self.changePasswordVC.newPasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
            if let error = error {
                self.changePasswordVC.showAlert(title: "Error", message: error.localizedDescription )
            }else{
                self.changePasswordVC.showAlert(title: "Success", message: "Your password has been changed successfully.")
                self.changePasswordVC.newPasswordTF.text = ""
                self.changePasswordVC.oldPasswordTF.text = ""
                self.changePasswordVC.confirmNewPasswordTF.text = ""
            }
            self.networkingLoadingIndicator.endLoadingAnimation()
        })
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func changeEmail(_ newEmail: String) {
        networkingLoadingIndicator.startLoadingAnimation()
        Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
            if let error = error {
                self.changeEmailVC.showAlert(title: "Error", message: error.localizedDescription)
                self.networkingLoadingIndicator.endLoadingAnimation()
                return
            }else{
                self.changeEmailHandler(newEmail)
                self.changeEmailVC.newEmailTF.text = ""
                self.changeEmailVC.confirmNewEmailTF.text = ""
            }
        })
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func changeEmailHandler(_ newEmail: String) {
        Database.database().reference().child("users").child(CurrentUser.uid).updateChildValues(["email":newEmail]) { (error, databaseRef) in
            self.networkingLoadingIndicator.endLoadingAnimation()
            if let error = error {
                self.changeEmailVC.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            self.changeEmailVC.showAlert(title: "Success", message: "Your email has been changed successfully")
            CurrentUser.email = newEmail
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
