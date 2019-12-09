//
//  Calendar + Extension.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/8/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

let calendar = Calendar(identifier: .gregorian)
extension Calendar {
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
}
