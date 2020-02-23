//
//  AppColors+CoreDataProperties.swift
//  
//
//  Created by Vitaliy Paliy on 2/22/20.
//
//

import Foundation
import CoreData


extension AppColors {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppColors> {
        return NSFetchRequest<AppColors>(entityName: "AppColors")
    }

    @NSManaged public var selectedIncomingColor: NSObject?
    @NSManaged public var selectedOutcomingTextColor: NSObject?
    @NSManaged public var selectedIncomingTextColor: NSObject?
    @NSManaged public var selectedBackgroundColor: NSObject?
    @NSManaged public var selectedOutcomingColor: NSObject?

}
