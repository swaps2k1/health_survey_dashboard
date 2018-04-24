//
//  NSDateComponents.swift
//  ResearchKit App
//
//  Created by Kokate, Tejas (US - Mumbai) on 4/23/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import Foundation

extension DateComponents {
    static var firstDateOfCurrentWeek: DateComponents {
        var beginningOfWeek: NSDate?
        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        gregorian?.locale = Locale.current
        gregorian!.range(of: .weekOfYear, start: &beginningOfWeek, interval: nil, for: Date())
        let dateComponents = gregorian?.components([.era, .year, .month, .day],
                                                   from: beginningOfWeek! as Date)
        return dateComponents!
    }
}
