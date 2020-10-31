//
//  TextField + DatePicker.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/9/17.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import Foundation
import UIKit

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
        
        self.inputAccessoryView = toolBar ///inputAccessoryView puts toolBar above the datePicker.
    }
    
    @objc func tappedCancel() {
        self.resignFirstResponder()
    }
}
