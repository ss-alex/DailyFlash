//
//  Helper.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/8/8.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

extension UIColor {
    static let customDarkGray = UIColor(red: 30/255.0, green: 28/255.0, blue: 28/255.0, alpha: 1)
    
    static let customLightGray = UIColor(red: 43/255.0, green: 41/255.0, blue: 41/255.0, alpha: 1)
    
    static let customWhiteTitle = UIColor(red: 184/255.0, green: 184/255.0, blue: 184/255.0, alpha: 1)
    
    static let customGreen = UIColor(red: 16/255.0, green: 158/255.0, blue: 39/255.0, alpha: 1)
    
    static let customBlue = UIColor(red: 31/255.0, green: 127/255.0, blue: 209/255.0, alpha: 1)
    
    static let customYellow = UIColor(red: 251/255.0, green: 255/255.0, blue: 37/255.0, alpha: 1)
    
    static let customRed = UIColor(red: 194/255.0, green: 46/255.0, blue: 74/255.0, alpha: 1)
}

enum ModulesMessages {
    static let moreThanOneMonth = "In more than one month"
    
    static let moreThanOneWeek = "In more than one week"
    
    static let lessThanOneWeek = "In less than one week"
    
    static let lessThanOneDay = "In less than one day"
}

extension UITextField {
    
    func setupInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(
            x: 0,
            y: 0,
            width: screenWidth,
            height: 216)
        )
        
        datePicker.datePickerMode = .date
        self.inputView = datePicker //assigning the datePicker instead of the keyboard
        
        let flexible = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        
        let cancel = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: nil,
            action: #selector(tappedCancel)
        )
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: target,
            action: selector
        )
        
        let toolBar = UIToolbar(frame: CGRect(
            x: 0,
            y: 0,
            width: screenWidth,
            height: 44)
        )
        
        toolBar.setItems([cancel, flexible, doneButton], animated: false)
        
        self.inputAccessoryView = toolBar //inputAccessoryView puts toolBar above the datePicker.
    }
    
    @objc func tappedCancel() {
        self.resignFirstResponder()
    }
}






/*
let dateFormater = DateFormatter()
dateFormater.dateStyle = .medium
let stringFromDate = dateFormater.string(from: storyDate)
print(">>>>DatePicker Check -> The string from date: \(stringFromDate)")
*/
