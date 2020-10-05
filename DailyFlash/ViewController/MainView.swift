//
//  MainView.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/7/27.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit
import CoreData


var events: [NSManagedObject] = []

var eventsDatesArray: [NSDate] = []

final class MainView: UIViewController {
    
    let actionButton = UIButton()
    
    var moduleViewOne = CustomView()
    var moduleViewTwo = CustomView()
    var moduleViewThree = CustomView()
    var moduleViewFour = CustomView()
    
    var moduleViews: [UIView] = []
    
    let tableView = UITableView()
    
    var countGreenEvents: Int = 0
    var countBlueEvents: Int = 0
    var countYellowEvents: Int = 0
    var countRedEvents: Int = 0
    
    var indicatorColor: UIColor = UIColor.purple

    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDataFromDB()
        configureModuleIndexes()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 30/255.0, green: 28/255.0, blue: 28/255.0, alpha: 1)
        
        moduleViewsInit()
        
        setupNavigation()
        setupActionButton()
        setupModuleViews()
        setupTableView()
    }
    
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupActionButton() {
        view.addSubview(actionButton)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        let top = actionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        let left = actionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        let right = actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        let height = actionButton.heightAnchor.constraint(equalToConstant: 120)
        NSLayoutConstraint.activate([top, left, right, height])
        
        actionButton.backgroundColor = .customLightGray
        actionButton.layer.cornerRadius = 20
        actionButton.setTitle("Create an event", for: .normal)
        actionButton.setTitleColor(.customWhiteTitle, for: .normal)
        
        actionButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
    }
    
    @objc private func createEvent() {
        self.navigationController?.pushViewController(CreateStoryVC(), animated: true)
    }
    
    private func setupModuleViews() {
        
        moduleViews = [moduleViewOne, moduleViewTwo, moduleViewThree, moduleViewFour]
        
        for moduleView in moduleViews {
            view.addSubview(moduleView)
            moduleView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                moduleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
                moduleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
                moduleView.heightAnchor.constraint(equalToConstant: 42)
            ])
        }
        
        NSLayoutConstraint.activate([
            moduleViewOne.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 48),
            moduleViewTwo.topAnchor.constraint(equalTo: moduleViewOne.bottomAnchor, constant: 5),
            moduleViewThree.topAnchor.constraint(equalTo: moduleViewTwo.bottomAnchor, constant: 5),
            moduleViewFour.topAnchor.constraint(equalTo: moduleViewThree.bottomAnchor, constant: 5)
        ])
    }
    
    private func setupTableView() {
            view.addSubview(tableView)
            tableView.backgroundColor = .yellow
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            let top = tableView.topAnchor.constraint(equalTo: moduleViewFour.bottomAnchor, constant: 20)
            let left = tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
            let right = tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
            let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
            NSLayoutConstraint.activate([top, left, right, bottom])
            
            tableView.register(CustomCell.self, forCellReuseIdentifier: "customCell")
            tableView.dataSource = self
            tableView.delegate = self
            tableView.reloadData()
        }
    
    
    private func fetchDataFromDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Story")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchResult = try managedContext.fetch(fetchRequest)
            
            events = fetchResult
            print("MainView. Fetched managed objects from 'events': \(events)")
            
            for data in fetchResult {
                
                if let dateResult = data.value(forKey: "date") {
                    eventsDatesArray.append(dateResult as! NSDate)
                    
                    print("MainView. eventsDatesArray is populated - \(eventsDatesArray)")
                } else {
                    print("MainView. eventsDatesArray can't be populated because dateResult is nil")
                }
            }
            
            
        } catch let error as NSError {
            print("MainView: couldn't fetch data from DB \(error)")
        }
    }
    
    private func configureModuleIndexes() {
        let datesArray = eventsDatesArray
        
        if datesArray.isEmpty == false {
        
            for date in datesArray {
                let currentDateLocal = Helper.convertDateToLocalDate()
                let endDate = date
                let dif = Helper.daysBetween(startDate: currentDateLocal, endDate: endDate as Date)
                    
                self.countIndexes(eventDate: endDate as Date, currentDateLocal: currentDateLocal, dif: dif)
            }
            
        } else {
            print("MainView. datesArray IS EMPTY. No possible to work through dates.")
        }
    }
    
    private func countIndexes(eventDate: Date, currentDateLocal: Date, dif: Int) {
        
        if currentDateLocal < eventDate && dif >= 30 {
            countGreenEvents += 1
            print("countGreenEvents calculation - \(countGreenEvents)")
            
        } else if currentDateLocal < eventDate && dif >= 7 && dif < 30 {
            countBlueEvents += 1
            print("countBlueEvents calculation - \(countBlueEvents)")
            
        } else if currentDateLocal < eventDate && dif >= 1 && dif < 7 {
            countYellowEvents += 1
            print("countYellowEvents calculation - \(countYellowEvents)")
            
        } else if currentDateLocal < eventDate && dif >= 0 && dif < 1 {
            countRedEvents += 1
            print("countRedEvents calculation - \(countRedEvents)")
            
        } else {
            print("This event is in gray zone = expired. Date - \(eventDate)")
        }
    }
    
    private func moduleViewsInit() {
        
            self.moduleViewOne = CustomView(imgViewColor: .customGreen,
                                            text: ModulesMessages.moreThanOneMonth,
                                            number: countGreenEvents)
            
            self.moduleViewTwo = CustomView(imgViewColor: .customBlue,
                                            text: ModulesMessages.moreThanOneWeek,
                                            number: countBlueEvents)
            
            self.moduleViewThree = CustomView(imgViewColor: .customYellow,
                                              text: ModulesMessages.lessThanOneWeek,
                                              number: countYellowEvents)
            
            self.moduleViewFour = CustomView(imgViewColor: .customRed,
                                             text: ModulesMessages.lessThanOneDay,
                                             number: countRedEvents)
    }
    
}

extension MainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        
        let title = event.value(forKey: "title") as? String ?? "No title"
        let date = event.value(forKey: "date") as? Date ?? Date(timeIntervalSinceNow: .infinity)
        
    
        let currentDateLocal = Helper.convertDateToLocalDate()
        let endDate = date
        let dif = Helper.daysBetween(startDate: currentDateLocal, endDate: endDate)
            
            
            
            //self.indicator.backgroundColor = self.setupIndicatorColor(dif: dif, currentDateLocal: currentDateLocal)
        
        if currentDateLocal < endDate && dif >= 30 {
            indicatorColor = UIColor.systemGreen
                
        } else if currentDateLocal < endDate && dif >= 7 && dif < 30 {
            indicatorColor = UIColor.systemBlue
                
        } else if currentDateLocal < endDate && dif >= 1 && dif < 7 {
            indicatorColor = UIColor.systemYellow
                
        } else if currentDateLocal < endDate && dif >= 0 && dif < 1 {
            indicatorColor = UIColor.systemRed
                
        } else {
            indicatorColor = UIColor.systemGray
        }
        
        cell.set(title: title, savedEventDate: date, color: indicatorColor)
        
        return cell
    }
}

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            self.deleteData(at: indexPath)
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (contextualAction, view, boolValue) in
            self.editData(at: indexPath)
        }
        
        editAction.backgroundColor = .black
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeActions
    }
    
    func deleteData(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let event = events[indexPath.row]
        
        managedContext.delete(event)
        events.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func editData(at indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

