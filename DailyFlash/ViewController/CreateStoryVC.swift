//
//  CreateStoryVC.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/7/27.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit
import CoreData

final class CreateStoryVC: UIViewController {
    
    let eventNameLabel = UILabel()
    var eventNameTF = UITextField()
    
    let dateLabel = UILabel()
    let dateTF = UITextField()
    var dateTFString: String = ""
    
    let datePicker = UIDatePicker()
    
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    var layoutElements: [UIView] = []
    
    override func viewDidLoad() {
        setupView()
        
        currentDate()
    }
    
    private func setupView() {
        setupEventNameLabel()
        setupEventNameTF()
        
        setupDateLabel()
        setupDateTF()
        
        setupSaveButton()
        setupCancelButton()
        
        setupUI()
    }
    
    private func currentDate() {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        
        print("CreateStoryVC. Current date and time: \(dateString)")
    }
    
    private func setupEventNameLabel() {
        eventNameLabel.text = "Event name"
        eventNameLabel.textColor = .customWhiteTitle
    }
    
    private func setupEventNameTF() {
        eventNameTF.backgroundColor = .customLightGray
        eventNameTF.layer.cornerRadius = 20
    }
    
    private func setupDateLabel() {
        dateLabel.text = "Date"
        dateLabel.textColor = .customWhiteTitle
    }
    
    private func setupDateTF() {
        dateTF.backgroundColor = .customLightGray
        dateTF.layer.cornerRadius = 20
        
        dateTF.setupInputViewDatePicker(target: self, selector: #selector(tappedDone))
    }
    
    @objc func tappedDone() {
        if let datePicker = dateTF.inputView as? UIDatePicker {
            
            let dateFormatter = DateFormatter()
            //dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            dateTF.text = dateFormatter.string(from: datePicker.date)
            print("CreateStoryVC: dateTF got the date from the datePicker - \(dateTF.text)")
            
            dateTFString = dateTF.text!
            print("CreateStoryVC: 'dateTFString' from 'dateTF.text' - \(dateTFString)")
        }
        
        dateTF.resignFirstResponder()
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        let currentDate = Date()
        datePicker.minimumDate = currentDate
        
        datePicker.setValue(UIColor.customWhiteTitle, forKey: "textColor")
        datePicker.subviews[0].subviews[1].backgroundColor = .customWhiteTitle
        datePicker.subviews[0].subviews[2].backgroundColor = .customWhiteTitle
        
    }
    
    private func setupSaveButton() {
        saveButton.backgroundColor = .green
        saveButton.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
    }
    
    private func setupCancelButton() {
        cancelButton.backgroundColor = .blue
        cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
    }
    
    private func setupUI() {
        
        layoutElements = [eventNameLabel, eventNameTF, dateLabel, dateTF, saveButton, cancelButton]
        
        for layoutElement in layoutElements {
            view.addSubview(layoutElement)
            layoutElement.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            eventNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            eventNameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            eventNameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            eventNameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            eventNameTF.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 5),
            eventNameTF.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            eventNameTF.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            eventNameTF.heightAnchor.constraint(equalToConstant: 60),
            
            dateLabel.topAnchor.constraint(equalTo: eventNameTF.bottomAnchor, constant: 20),
            dateLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            dateLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            dateLabel.heightAnchor.constraint(equalToConstant: 24),
            
            dateTF.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            dateTF.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            dateTF.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            dateTF.heightAnchor.constraint(equalToConstant: 60),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            saveButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            saveButton.widthAnchor.constraint(equalToConstant: (view.frame.width/2) - 30),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            cancelButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            cancelButton.widthAnchor.constraint(equalToConstant: (view.frame.width/2) - 30),
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func saveToDB(date: Date, title: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Story", in: managedContext)!
        
        let story = NSManagedObject(entity: entity, insertInto: managedContext)
        
        story.setValue(title, forKey: "title")
        story.setValue(date, forKey: "date")
        
        do {
            try managedContext.save()
            events.append(story)
        } catch let error as NSError {
            print("CreateStoryVC: Couldn't save. \(error), \(error.userInfo)")
        }
        
    }
    
    @objc func saveEvent() {
        
        //[Here should be the check for empty entities.]
        //[If the user hasn't picked the date or hasn't written the title the user should see the Alert before the save action is implemented.]
        //[Need to resolve dates issue, if I pick 30th of May, 29th of May will be saved for some reason.]
        //[Navigation should be implemented like the move backword not like a pop-up.]
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFromString = dateFormatter.date(from: dateTFString)
        
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let localTimeZone = TimeZone.current
        
        let sourceOffset = sourceTimeZone?.secondsFromGMT(for: dateFromString!)
        let destinationOffset = localTimeZone.secondsFromGMT(for: dateFromString!)
        
        let timeInterval: TimeInterval = Double(destinationOffset - sourceOffset!)
        
        let convertedDate = Date(timeInterval: timeInterval, since: dateFromString!)
        print("CreateStoryVC. Converted date = \(convertedDate)")
        
        let eventDate = convertedDate
        print("Create StoryVC. Event DATE fetched successfuly: \(eventDate)")
     
        guard let titleText = eventNameTF.text else {
            return print("CreateStoryVC: titleTF has no instance")
        }
        print("Create StoryVC. Event NAME fetched successfully: \(titleText)")
        
        self.saveToDB(date: eventDate, title: titleText ?? "No title")
        
        print(">>>>Save button is tapped: Story being saved")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelEvent() {
        
        print(">>>>Cancel button is tapped: Story being cancelled")
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CreateStoryVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
