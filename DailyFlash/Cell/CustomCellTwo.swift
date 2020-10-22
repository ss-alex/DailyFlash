//
//  CustomCell.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/8/8.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class CustomCellTwo: UITableViewCell {
    
    private let backView = UIView()
    
    private let titleLabel = UILabel()
    private let countdownLabel = UILabel()
    private let indicator = UIImageView()
    
    private let customSize: CGFloat = 24
    
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
        backgroundColor = .customDarkGray
        setupBackView()
        
        setupTitleLabel()
        setupCountDownLabel()
        setupIndicator()
        
        setupTimer()
    }
    
    private func setupBackView() {
        addSubview(backView)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        let top = backView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6)
        let left = backView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        let right = backView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        let bottom = backView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6)
        NSLayoutConstraint.activate([top, left, right, bottom])
        
        backView.backgroundColor = .customLightGray
        backView.layer.cornerRadius = 20
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowRadius = 4
        backView.layer.shadowOffset = CGSize(width: 0, height: 4)
        backView.layer.shadowOpacity = 0.8
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = titleLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 18)
        let left = titleLabel.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 16)
        let width = titleLabel.widthAnchor.constraint(equalToConstant: 240)
        let height = titleLabel.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([top, left, width, height])
        
        titleLabel.font = UIFont(name: "Mada-Regular", size: 24)
        titleLabel.textColor = .customWhite
    }
    
    private func setupCountDownLabel() {
        addSubview(countdownLabel)
        
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = countdownLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 11)
        let left = countdownLabel.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 16)
        let right = countdownLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -24)
        let height = countdownLabel.heightAnchor.constraint(equalToConstant: 28)
        NSLayoutConstraint.activate([top, left, right, height])
        
        countdownLabel.font = UIFont(name: "Mada-Bold", size: 34)
        countdownLabel.textColor = .customWhite
    }
    
    private func setupIndicator() {
        addSubview(indicator)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        let yAnchor = indicator.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        let right = indicator.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -24)
        let width = indicator.widthAnchor.constraint(equalToConstant: customSize)
        let height = indicator.heightAnchor.constraint(equalToConstant: customSize)
        NSLayoutConstraint.activate([yAnchor, right, width, height])
        
        indicator.layer.cornerRadius = customSize/2
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            //timeInterval: 10.0,
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
        
        
        let createdAttributedString = Helper.createAttributedString(
            defaultUIFont: UIFont(name: "Mada-Bold", size: 34)!,
            defaultColor: UIColor.customWhite,
            customFont: UIFont(name: "CantoraOne-Regular", size: 24)!,
            customColor: UIColor.customRed,
            stringComponentOne: timeLeft.day!,
            stringComponentTwo: timeLeft.hour!,
            stringComponentThree: timeLeft.minute!,
            stringComponentFour: timeLeft.second!
        )
        
        if savedDate >= currentDateLocal {
            countdownLabel.attributedText = createdAttributedString as! NSAttributedString
        } else {
            countdownLabel.text = "EXPIRED"
        }
    }
    
}
