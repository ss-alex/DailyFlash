//
//  CustomCell.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/8/8.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let countdownLabel = UILabel()
    private let indicatorImageView = UIImageView()
    
    private let customSize: CGFloat = 14
    
    var timer: Timer!
    
    var savedDate: Date!
    
    var currentDate: Date!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        
        
        //let endDate = savedDate!
        
        //let dif = daysBetween(startDate: currentDateLocal, endDate: endDate)
        //print("CustomCell. Dif between dates - \(dif)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     //MARK:- Public
    func set(title: String, savedEventDate: Date) {
        self.titleLabel.text = title
        self.savedDate = savedEventDate
    }
    
    private func setup() {
        setupTitleLabel()
        setupCountDownLabel()
        setupIndicator()
        
        setupTimer()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        let left = titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        let width = titleLabel.widthAnchor.constraint(equalToConstant: 150)
        let height = titleLabel.heightAnchor.constraint(equalToConstant: 24)
        NSLayoutConstraint.activate([top, left, width, height])
        
        titleLabel.backgroundColor = .systemGray
    }
    
    private func setupCountDownLabel() {
        addSubview(countdownLabel)
        
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = countdownLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        let left = countdownLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        let right = countdownLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        let height = countdownLabel.heightAnchor.constraint(equalToConstant: 24)
        NSLayoutConstraint.activate([top, left, right, height])
        
        countdownLabel.backgroundColor = .systemGray
    }
    
    private func setupIndicator() {
        addSubview(indicatorImageView)
        
        indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        let yAnchor = indicatorImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        let right = indicatorImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        let width = indicatorImageView.widthAnchor.constraint(equalToConstant: customSize)
        let height = indicatorImageView.heightAnchor.constraint(equalToConstant: customSize)
        NSLayoutConstraint.activate([yAnchor, right, width, height])
        
        indicatorImageView.layer.cornerRadius = customSize/2
        
        DispatchQueue.main.async {
            let currentDateLocal = self.convertDateToLocalDate()
            let endDate = self.savedDate!
            
            let dif = self.daysBetween(startDate: currentDateLocal, endDate: endDate)
            
            self.indicatorImageView.backgroundColor = self.setupIndicatorColor(dif: dif, currentDateLocal: currentDateLocal)
        }
    }
    
    private func setupIndicatorColor(dif: Int, currentDateLocal: Date) -> UIColor {
        
        if currentDateLocal < savedDate && dif >= 30 {
            return UIColor.systemGreen
            
        } else if currentDateLocal < savedDate && dif >= 7 && dif < 30 {
            return UIColor.systemBlue
            
        } else if currentDateLocal < savedDate && dif >= 1 && dif < 7 {
            return UIColor.systemYellow
            
        } else if currentDateLocal < savedDate && dif >= 0 && dif < 1 {
            return UIColor.systemRed
            
        } else {
            return UIColor.systemGray
        }
    }
    
    private func daysBetween(startDate: Date, endDate: Date) -> Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(
            //timeInterval: 0.1,
            timeInterval: 10.0,
            target: self,
            selector: #selector(updateTime),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func updateTime() {
        
        let currentDateLocal = convertDateToLocalDate()
        
        let timeLeft = Calendar.current.dateComponents([
            .day,
            .hour,
            .minute,
            .second],
            from: currentDateLocal,
            to: savedDate)
        
        if savedDate >= currentDateLocal {
            countdownLabel.text = "\(timeLeft.day!)d \(timeLeft.hour!)h \(timeLeft.minute!)m \(timeLeft.second!)s"
        } else {
            countdownLabel.text = "EXPIRED"
        }
    }
    
    private func convertDateToLocalDate() -> Date  {
        
        let date = Date()
        
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let localTimeZone = TimeZone.current
        
        let sourceOffset = (sourceTimeZone?.secondsFromGMT(for: date))!
        let destinationOffset = localTimeZone.secondsFromGMT(for: date)
        
        let timeInterval: TimeInterval = Double(destinationOffset - sourceOffset)
        let currentDateLocal = Date(timeInterval: timeInterval, since: date)
        
        return currentDateLocal
    }
}
