//
//  AppDelegate.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "mChat")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        guard let userId = CurrentUser.uid else { return }
        let userRef = Database.database().reference().child("userActions").child(userId)
        userRef.removeValue()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

