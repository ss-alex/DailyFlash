//
//  CreateStoryVC.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/7/27.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit
import CoreData

final class CreateEventVC: UIViewController {
    
    let eventNameLabel = CustomLabel(textColor: .customWhiteTitle, text: "Event name")
    var eventNameTF = CustomTF()
    
    let dateLabel = CustomLabel(textColor: .customWhiteTitle, text: "Date")
    var dateTF = CustomTF()
    var dateTFString: String = ""
    
    let datePicker = UIDatePicker()
    
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    var layoutElements: [UIView] = []
    
    var editFlag: Bool = false
    var editEventName: String = ""
    var editEventDate: String = ""
    var editIndex: Int = 0
    
    var delegate: DataDelegate?
    
    init(editFlag: Bool) {
        self.editFlag = editFlag
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if editFlag == true {
            eventNameTF.text = editEventName
            dateTF.text = editEventDate
        } else {
            eventNameTF.text = PlaceholderText.nameTheEvent
            dateTF.text = PlaceholderText.pickTheDate
        }
    }
    
    private func setupView() {
        setupDateTF()
        setupSaveButton()
        setupCancelButton()
        
        setupLayout()
    }
    
    //MARK:- Logic
    
    private func setupEventNameTF() {
        
    }
    
    private func setupDateTF() {
        dateTF.setupInputViewDatePicker(target: self, selector: #selector(tappedDone))
    }
    
    @objc func tappedDone() {
        if editFlag == true {
            
            if let datePicker = dateTF.inputView as? UIDatePicker {
                dateTF.text = Helper.convertDateToString(date: datePicker.date)
                editEventDate = dateTF.text!
            }
            
        } else {
            
            if let datePicker = dateTF.inputView as? UIDatePicker {
                dateTF.text = Helper.convertDateToString(date: datePicker.date)
                dateTFString = dateTF.text!
            }
        }
        
        dateTF.resignFirstResponder()
    }
    
    
    private func setupSaveButton() {
        saveButton.backgroundColor = .green
        saveButton.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
    }
    
    @objc func saveEvent() {
        if editFlag == true {

            guard let editName = eventNameTF.text else {
                return print("CreateEventVC, saveEvent(), editName is empty - \(String(describing: eventNameTF.text)) ")
            }
            
            let editConvertedDate = Helper.convertDateInLocalTimeZone(dateTFString: editEventDate)
            
            Helper.editToDB(editIndex: editIndex, editName: editName, editDate: editConvertedDate)
            
            self.editFlag = false
            self.navigationController?.pushViewController(MainView(), animated: true)
            
        } else {
            
            let convertedDate = Helper.convertDateInLocalTimeZone(dateTFString: dateTFString)
            
            guard let titleText = eventNameTF.text else {
                return print("titleTF has no instance")
            }
            
            Helper.saveToDB(date: convertedDate, title: titleText ?? "No title")
            self.navigationController?.pushViewController(MainView(), animated: true)
        }
    }
    
    private func setupCancelButton() {
        cancelButton.backgroundColor = .blue
        cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
    }
    
    @objc func cancelEvent() {
        self.editFlag = false
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UI Elements
    private func setupLayout() {
        
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
    
}

extension CreateEventVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}