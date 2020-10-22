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
            //return UIColor.systemGreen
            return .customGreen
                
        } else if currentDateLocal < endDate && dif >= 7 && dif < 30 {
            //return UIColor.systemBlue
            return .customBlue
                
        } else if currentDateLocal < endDate && dif >= 1 && dif < 7 {
            //return UIColor.systemYellow
            return .customYellow
                
        } else if currentDateLocal < endDate && dif >= 0 && dif < 1 {
            //return UIColor.systemRed
            return .customRed
                
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
            eventArray.append(event)
        } catch let error as NSError {
            print("CreateStoryVC: Couldn't save. \(error), \(error.userInfo)")
        }
    }
    
    
    static func editToDB(editIndex: Int, editName: String, editDate: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Story")
        
        
        do {
            
            let results = try managedContext.fetch(fetchRequest)
            
            let managedObject = results[editIndex]
            managedObject.setValue(editName, forKey: "title")
            managedObject.setValue(editDate, forKey: "date")
            
            try managedContext.save()
            print("update successful")
            
        } catch let error as NSError {
            print("CreateEventVC: couldn't fetch data from DB \(error)")
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
    
    
    static func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.string(from: date)
    }
    
    
    static func swipeDeleteLogic(eventArray: [NSManagedObject], indexPath: IndexPath, fileName: String, errorMessage: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let event = eventArray[indexPath.row]
        managedContext.delete(event)
        
        do {
            try managedContext.save()
        } catch {
            print("\(fileName) - \(errorMessage)")
        }
    }
    
    
    static func setupFetchDataFoundation() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Story")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let theFetchResult = try managedContext.fetch(fetchRequest)
            fetchResult = theFetchResult
            
        } catch let error as NSError {
            print("MainView: couldn't fetch data from DB \(error)")
        }
    }
    
    static func createAttributedString(defaultUIFont: UIFont,
                                       defaultColor: UIColor,
                                       customFont: UIFont,
                                       customColor: UIColor,
                                       stringComponentOne: Int,
                                       stringComponentTwo: Int,
                                       stringComponentThree: Int,
                                       stringComponentFour: Int) -> NSObject {
        let defaultAttributes = [
            .font: defaultUIFont,
            .foregroundColor: defaultColor
        ] as [NSMutableAttributedString.Key: Any]
        
        let timeAttributes = [
            .font: customFont,
            .foregroundColor: customColor
        ] as [NSAttributedString.Key: Any]
        
        let attributedStringComponents = [
            "\(stringComponentOne)",
            NSAttributedString(string: "d", attributes: timeAttributes),
            "\(stringComponentTwo)",
            NSAttributedString(string: "h", attributes: timeAttributes),
            "\(stringComponentThree)",
            NSAttributedString(string: "m", attributes: timeAttributes),
            "\(stringComponentFour)",
            NSAttributedString(string: "s", attributes: timeAttributes)
        ] as [AttributedStringComponent]
        
        return NSAttributedString(from: attributedStringComponents, defaultAttributes: defaultAttributes)!
    }
    
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


/*for family: String in UIFont.familyNames
{
    print(family)
    for names: String in UIFont.fontNames(forFamilyName: family)
    {
        print("== \(names)")
    }
}*/


/*let defaultAttributes = [.font: UIFont(name: "Mada-Bold", size: 34),
                         .foregroundColor: UIColor.customWhite
] as [NSMutableAttributedString.Key: Any]

let timeAttributes = [.font: UIFont(name: "CantoraOne-Regular", size: 24),
                      .foregroundColor: UIColor.customRed
] as [NSAttributedString.Key: Any]

let attributedStringComponents = [
    "\(timeLeft.day!)",
    NSAttributedString(string: "d", attributes: timeAttributes),
    
    "\(timeLeft.hour!)",
    NSAttributedString(string: "h", attributes: timeAttributes),
    
    "\(timeLeft.minute!)",
    NSAttributedString(string: "m", attributes: timeAttributes),
    
    "\(timeLeft.second!)",
    NSAttributedString(string: "s", attributes: timeAttributes)
    
] as [AttributedStringComponent]*/
