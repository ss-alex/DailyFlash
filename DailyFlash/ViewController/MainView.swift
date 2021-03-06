//
//  MainView.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/7/27.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit
import CoreData

protocol DataDelegate {}

var fetchResult: [NSManagedObject] = []

var eventArray: [NSManagedObject] = []
var eventDateArray: [NSDate] = []


final class MainView: UIViewController, DataDelegate {
    
    let actionButton = CreateEventButton()
    
    let upperTableView = UITableView()
    let lowerTableView = UITableView()
    
    var greenCounter: Int = 0
    var blueCounter: Int = 0
    var yellowCounter: Int = 0
    var redCounter: Int = 0
    
    var indicatorColor: UIColor = UIColor.purple
    
    //let colorsArray = [UIColor.green, UIColor.blue, UIColor.yellow, UIColor.red]
    let colorsArray: [UIColor] = [.customGreen, .customBlue, .customYellow, .customRed]
    
    let textArray = ["In more than one month",
                     "In more than one week",
                     "In less than one week",
                     "In less than one day"]
    
    var indexArray = [] as [Int]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogic()
        setupView()
    }
    
    //MARK:- Logic methods
    
    private func setupLogic() {
        setIndexArrayToZero()
        setCountersToZero()
        
        fetchDataFromDB()
        eventDateArrayPopulate()
        configureIndexCounters()
    }
    
    private func setIndexArrayToZero() {
        indexArray.removeAll()
        indexArray.insert(0, at: 0)
        indexArray.insert(0, at: 1)
        indexArray.insert(0, at: 2)
        indexArray.insert(0, at: 3)
    }
    
    private func setCountersToZero() {
        greenCounter = 0
        blueCounter = 0
        yellowCounter = 0
        redCounter = 0
    }
    
    private func fetchDataFromDB() {
        
        Helper.setupFetchDataFoundation()
        
        //Logic #1
        eventArray = fetchResult
        //Logic #2
        eventDateArray.removeAll()
    }
    
    private func eventDateArrayPopulate() {
        for data in fetchResult {
            if let dateResult = data.value(forKey: "date") {
                    eventDateArray.append(dateResult as! NSDate)
                    
            } else {
                    print("MainView. eventsDatesArray can't be populated because dateResult is nil")
            }
        }
    }
    
    private func configureIndexCounters() {
        
        let datesArray = eventDateArray
        
        if datesArray.isEmpty == false {
     
            for date in datesArray {
                let currentDateLocal = Helper.convertDateToLocalDate()
                let endDate = date
                let dif = Helper.daysBetween(startDate: currentDateLocal, endDate: endDate as Date)
                    
                self.countIndexes(eventDate: endDate as Date, currentDateLocal: currentDateLocal, dif: dif)
            }
            
            indexArray.removeAll()
            
            indexArray.insert(greenCounter, at: 0)
            indexArray.insert(blueCounter, at: 1)
            indexArray.insert(yellowCounter, at: 2)
            indexArray.insert(redCounter, at: 3)
            
        } else {
            print("MainView. datesArray IS EMPTY. No possible to work through dates.")
        }
    }
    
    private func countIndexes(eventDate: Date, currentDateLocal: Date, dif: Int) {
        
        if currentDateLocal < eventDate && dif >= 30 {
            greenCounter += 1

        } else if currentDateLocal < eventDate && dif >= 7 && dif < 30 {
            blueCounter += 1
           
        } else if currentDateLocal < eventDate && dif >= 1 && dif < 7 {
            yellowCounter += 1
            
        } else if currentDateLocal < eventDate && dif >= 0 && dif < 1 {
            redCounter += 1
                
        } else {
            print("MainView. countIndexes(), this event is in gray zone = expired. Date - \(eventDate)")
        }
    }
    
    //MARK:- UI Elements setup
    private func setupView() {
        view.backgroundColor = UIColor(red: 30/255.0, green: 28/255.0, blue: 28/255.0, alpha: 1)
    
        setupNavigation()
        setupActionButton()
        setupUpperTV()
        setupLowerTV()
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupActionButton() {
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            actionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 96)
        ])
        
        actionButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
    }
    
    private func setupUpperTV() {
        view.addSubview(upperTableView)
        upperTableView.translatesAutoresizingMaskIntoConstraints = false
        upperTableView.alwaysBounceVertical = false
        upperTableView.allowsSelection = false
        upperTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            upperTableView.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 38),
            upperTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            upperTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            upperTableView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        upperTableView.register(CustomCellOne.self, forCellReuseIdentifier: "upperCell")
        upperTableView.delegate = self
        upperTableView.dataSource = self
    }
    
    private func setupLowerTV() {
        view.addSubview(lowerTableView)
        lowerTableView.translatesAutoresizingMaskIntoConstraints = false
        lowerTableView.backgroundColor = .customDarkGray
        lowerTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            lowerTableView.topAnchor.constraint(equalTo: upperTableView.bottomAnchor,constant: 20),
            lowerTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            lowerTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            //lowerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-20)
            lowerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        lowerTableView.register(CustomCellTwo.self, forCellReuseIdentifier: "customCell")
        lowerTableView.delegate = self
        lowerTableView.dataSource = self
    }
    
    //MARK:- OBJC Methods
    @objc private func createEvent() {
        self.navigationController?.pushViewController(CreateEventVC(editFlag: false), animated: true)
    }
}

extension MainView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 1
        
        switch tableView {
        case upperTableView:
            numberOfRows = indexArray.count
            
        case lowerTableView:
            numberOfRows = eventArray.count
            
        default:
            print("MainView. numberOfRowsInSection COULDN'T be calculated.")
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.upperTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "upperCell", for: indexPath) as! CustomCellOne
            
            let indicatorColor = colorsArray[indexPath.row]
            let cellText = textArray[indexPath.row]
            let indexInt = indexArray[indexPath.row]
            
            cell.set(color: indicatorColor, text: cellText, index: indexInt)
            
            return cell
            
        } else {
            
            print("MainView. lowerTableView. Current IndexPath is - \(indexPath)")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCellTwo
            
            let event = eventArray[indexPath.row]
            let title = event.value(forKey: "title") as? String ?? "No title"
            
            let date = event.value(forKey: "date") as? Date ?? Date(timeIntervalSinceNow: .infinity)
            let currentDateLocal = Helper.convertDateToLocalDate()
            let endDate = date
            let dif = Helper.daysBetween(startDate: currentDateLocal, endDate: endDate)
            
            let color = Helper.defineColor(currentDateLocal: currentDateLocal, endDate: endDate, dif: dif)
        
            cell.set(title: title, savedEventDate: date, color: color)
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(1)

        switch tableView {
            
        case upperTableView:
            height = CGFloat(40)
            
        case lowerTableView:
            height = CGFloat(110)
            
        default:
            print("MainView. COULDN'T initiate the heightForRowAt.")
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var swipeAction = UISwipeActionsConfiguration()
        
        switch tableView {
        case upperTableView:
            swipeAction = UISwipeActionsConfiguration()
            
        case lowerTableView:
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
                self.deleteData(at: indexPath)
            }
            
            let editAction = UIContextualAction(style: .destructive, title: "Edit") { (contextualAction, view, boolValue) in
                self.editData(at: indexPath)
            }
            editAction.backgroundColor = .black
            
            swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            
        default:
            print("MainView. default case for swipe action.")
        }
        
        return swipeAction
    }
    
    func deleteData(at indexPath: IndexPath) {
        
        Helper.swipeDeleteLogic(eventArray: eventArray,
                           indexPath: indexPath,
                           fileName: FileNames.MainView.description,
                           errorMessage: ErrorMessages.managedContextCouldNotBeSaved.description)
        
        eventArray.remove(at: indexPath.row)
        
        lowerTableView.deleteRows(at: [indexPath], with: .fade)
        
        //launching the logic again..
        setupLogic()
        upperTableView.reloadData()
    }
    
    func editData(at indexPath: IndexPath) {
        let event = eventArray[indexPath.row]
        let title = event.value(forKey: "title") as? String ?? "No title"
        let date = event.value(forKey: "date") as? Date ?? Date(timeIntervalSinceNow: .infinity)
        
        let vc = CreateEventVC(editFlag: true)
        vc.delegate = self
        vc.editEventName = title
        vc.editEventDate = Helper.convertDateToString(date: date)
        vc.editIndex = indexPath.row
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.lowerTableView {
            if scrollView.contentOffset.y <= 0 {
                scrollView.contentOffset = CGPoint.zero
            }
        }
    }
    
}

