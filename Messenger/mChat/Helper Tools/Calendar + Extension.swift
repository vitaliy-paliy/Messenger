//
//  Calendar + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/8/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

extension Calendar {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // timeIntervalSince1970 num to a string.
    
    func calculateTimePassed(date: NSDate) -> String{
        let now = Date()
        let dataComponents = Calendar.current.dateComponents([.month, .day ,.hour, .minute], from: date as Date, to: now)
        if let month = dataComponents.month, month > 0{
            return month == 1 ? "\(month)" + " month ago" : "\(month)" + " months ago"
        }else if let day = dataComponents.day, day > 0 {
            return day == 1 ? "\(day)" + " day ago" : "\(day)" + " days ago"
        }else if let hour = dataComponents.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " hour ago" : "\(hour)" + " hours ago"
        }else if let minute = dataComponents.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " minute ago" : "\(minute)" + " minutes ago"
        }else{
            return "just now"
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func calculateLastLogin(_ date: NSDate) -> String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let lastSeenDate = dateFormatter.string(from: date as Date)
        let dataComponents = Calendar.current.dateComponents([.month, .day ,.hour, .minute], from: date as Date, to: now)
        if let month = dataComponents.month, month > 0{
            return "last seen " + lastSeenDate
        }else if let day = dataComponents.day, day > 0 {
            if day == 1{
                return "last seen \(day)" + " day ago"
            }else if day <= 7 {
                return "last seen \(day)" + " days ago"
            }else{
                return "last seen " + lastSeenDate
            }
        }else if let hour = dataComponents.hour, hour > 0 {
            return hour == 1 ? "last seen \(hour)" + " hour ago" : "last seen \(hour)" + " hours ago"
        }else if let minute = dataComponents.minute, minute > 0 {
            return minute == 1 ? "last seen \(minute)" + " minute ago" : "last seen \(minute)" + " minutes ago"
        }else{
            return "just now"
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
