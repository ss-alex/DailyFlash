//
//  Helper.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/8/8.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class Helper {
    static func convertDateToLocalDate() -> Date  {
        
        let date = Date()
        
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let localTimeZone = TimeZone.current
        
        let sourceOffset = (sourceTimeZone?.secondsFromGMT(for: date))!
        let destinationOffset = localTimeZone.secondsFromGMT(for: date)
        
        let timeInterval: TimeInterval = Double(destinationOffset - sourceOffset)
        let currentDateLocal = Date(timeInterval: timeInterval, since: date)
        
        return currentDateLocal
    }
    
    static func daysBetween(startDate: Date, endDate: Date) -> Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
    }
}


enum ModulesMessages {
    static let moreThanOneMonth = "In more than one month"
    
    static let moreThanOneWeek = "In more than one week"
    
    static let lessThanOneWeek = "In less than one week"
    
    static let lessThanOneDay = "In less than one day"
}
