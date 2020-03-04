//
//  UserActivity.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class UserActivity {

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // USERS ACTIVITY OBSERVER
    
    static func observe(isOnline: Bool) {
        
        guard let user = Auth.auth().currentUser else { return }
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(user.uid)
        userRef.child("isOnline").setValue(isOnline)
        userRef.child("lastLogin").setValue(Date().timeIntervalSince1970)
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
