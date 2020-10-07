//
//  Helper.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/8/8.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit
import CoreData

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
    
    static func defineColor(currentDateLocal: Date, endDate: Date, dif: Int) -> UIColor {
        if currentDateLocal < endDate && dif >= 30 {
            return UIColor.systemGreen
                
        } else if currentDateLocal < endDate && dif >= 7 && dif < 30 {
            return UIColor.systemBlue
                
        } else if currentDateLocal < endDate && dif >= 1 && dif < 7 {
            return UIColor.systemYellow
                
        } else if currentDateLocal < endDate && dif >= 0 && dif < 1 {
            return UIColor.systemRed
                
        } else {
            return UIColor.systemGray
        }
    }
    
    static func saveToDB(date: Date, title: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Story", in: managedContext)!
        
        let event = NSManagedObject(entity: entity, insertInto: managedContext)
        
        event.setValue(title, forKey: "title")
        event.setValue(date, forKey: "date")
        
        do {
            try managedContext.save()
            eventsArray.append(event)
        } catch let error as NSError {
            print("CreateStoryVC: Couldn't save. \(error), \(error.userInfo)")
        }
    }
    
    static func convertDateInLocalTimeZone(dateTFString: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFromString = dateFormatter.date(from: dateTFString)
        
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let localTimeZone = TimeZone.current
        
        let sourceOffset = sourceTimeZone?.secondsFromGMT(for: dateFromString!)
        let destinationOffset = localTimeZone.secondsFromGMT(for: dateFromString!)
        
        let timeInterval: TimeInterval = Double(destinationOffset - sourceOffset!)
        let convertedDate = Date(timeInterval: timeInterval, since: dateFromString!)
        
        return convertedDate
    }
}


enum ModulesMessages {
    static let moreThanOneMonth = "In more than one month"
    
    static let moreThanOneWeek = "In more than one week"
    
    static let lessThanOneWeek = "In less than one week"
    
    static let lessThanOneDay = "In less than one day"
}



/*private func setupDatePicker() {
    datePicker.datePickerMode = .date
    let currentDate = Date()
    datePicker.minimumDate = currentDate
    
    datePicker.setValue(UIColor.customWhiteTitle, forKey: "textColor")
    datePicker.subviews[0].subviews[1].backgroundColor = .customWhiteTitle
    datePicker.subviews[0].subviews[2].backgroundColor = .customWhiteTitle
    
}*/


/*private func currentDate() {
    let date = Date()
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateString = df.string(from: date)
}*/
