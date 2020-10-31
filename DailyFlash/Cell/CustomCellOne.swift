//
//  CustomCellTwo.swift
//  DailyFlash
//
//  Created by Лена Мырленко on 2020/9/29.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import Foundation
import UIKit

class CustomCellOne: UITableViewCell {
    
    private let indicatorView = UIView()
    private let eventLabel = UILabel()
    private let eventIndex = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        
        setupIndicatorView()
        setupEventTitle()
        setupEventIndex()
        
        backgroundColor = .customDarkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(color: UIColor, text: String, index: Int) {
        indicatorView.backgroundColor = color
        eventLabel.text = text
        eventIndex.text = String(index)
    }
    
    private func setupLayout() {
        self.addSubview(indicatorView)
        self.addSubview(eventLabel)
        self.addSubview(eventIndex)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        eventIndex.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            indicatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            indicatorView.widthAnchor.constraint(equalToConstant: 14),
            indicatorView.heightAnchor.constraint(equalToConstant: 14),
            
            eventIndex.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            eventIndex.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            eventIndex.widthAnchor.constraint(equalToConstant: 20),
            eventIndex.heightAnchor.constraint(equalToConstant: 30),
            
            eventLabel.leftAnchor.constraint(equalTo: indicatorView.rightAnchor, constant: 10),
            eventLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            eventLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            eventLabel.widthAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func setupIndicatorView() {
        indicatorView.layer.cornerRadius = 14/2
    }
    
    private func setupEventTitle() {
        eventLabel.font = UIFont(name: "Mada-Light", size: 22)
        eventLabel.textColor = .customWhite
        
        eventLabel.numberOfLines = 0 /// it allows any number of lines
        eventLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setupEventIndex() {
        eventIndex.font = UIFont(name: "Mada-Medium", size: 30)
        eventIndex.textColor = .customWhite
        eventIndex.textAlignment = .center
    }
    

    
}
