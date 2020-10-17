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
    private let eventTitle = UILabel()
    private let eventIndex = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(color: UIColor, text: String, index: Int) {
        indicatorView.backgroundColor = color
        eventTitle.text = text
        eventIndex.text = String(index)
    }
    
    private func setupLayout() {
        self.addSubview(indicatorView)
        self.addSubview(eventTitle)
        self.addSubview(eventIndex)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        eventTitle.translatesAutoresizingMaskIntoConstraints = false
        eventIndex.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            indicatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            indicatorView.widthAnchor.constraint(equalToConstant: 20),
            
            eventIndex.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            eventIndex.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            eventIndex.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            eventIndex.widthAnchor.constraint(equalToConstant: 20),
            
            eventTitle.leftAnchor.constraint(equalTo: indicatorView.rightAnchor, constant: 10),
            eventTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            eventTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            eventTitle.rightAnchor.constraint(equalTo: eventIndex.leftAnchor, constant: -10)
        ])
        
        
    }
    

    
}
