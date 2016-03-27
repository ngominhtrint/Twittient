//
//  TimeAgo.swift
//  Twittient
//
//  Created by TriNgo on 3/25/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//


import Foundation

public func timeAgoSince(date: NSDate) -> String {
    
    let calendar = NSCalendar.currentCalendar()
    let now = NSDate()
    let unitFlags: NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfYear, .Month, .Year]
    let components = calendar.components(unitFlags, fromDate: date, toDate: now, options: [])
    
    if components.year >= 2 {
        return "\(components.year)y"
    }
    
    if components.year >= 1 {
        return "1y"
    }
    
    if components.month >= 2 {
        return "\(components.month)m"
    }
    
    if components.month >= 1 {
        return "1m"
    }
    
    if components.weekOfYear >= 2 {
        return "\(components.weekOfYear)w"
    }
    
    if components.weekOfYear >= 1 {
        return "1w"
    }
    
    if components.day >= 2 {
        return "\(components.day)d"
    }
    
    if components.day >= 1 {
        return "1d"
    }
    
    if components.hour >= 2 {
        return "\(components.hour)h"
    }
    
    if components.hour >= 1 {
        return "1h"
    }
    
    if components.minute >= 2 {
        return "\(components.minute)min"
    }
    
    if components.minute >= 1 {
        return "1min"
    }
    
    if components.second >= 3 {
        return "\(components.second)s"
    }
    
    return "now"
    
}


