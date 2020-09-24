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
    private let indicator = UIImageView()
    
    private let customSize: CGFloat = 14
    
    var timer: Timer!
    
    var savedDate: Date!
    
    var currentDate: Date!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     //MARK:- Public
    func set(title: String, savedEventDate: Date, color: UIColor) {
        self.titleLabel.text = title
        self.savedDate = savedEventDate
        self.indicator.backgroundColor = color
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
        addSubview(indicator)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        let yAnchor = indicator.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        let right = indicator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        let width = indicator.widthAnchor.constraint(equalToConstant: customSize)
        let height = indicator.heightAnchor.constraint(equalToConstant: customSize)
        NSLayoutConstraint.activate([yAnchor, right, width, height])
        
        indicator.layer.cornerRadius = customSize/2
        
        /*DispatchQueue.main.async {
            let currentDateLocal = Helper.convertDateToLocalDate()
            let endDate = self.savedDate!
            
            let dif = Helper.daysBetween(startDate: currentDateLocal, endDate: endDate)
            
            self.indicator.backgroundColor = self.setupIndicatorColor(dif: dif, currentDateLocal: currentDateLocal)
        }*/
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
        
        let currentDateLocal = Helper.convertDateToLocalDate()
        
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
    
}
