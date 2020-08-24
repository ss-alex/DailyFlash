//
//  CustomView.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/8/8.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    let circleImgView = UIImageView()
    let textLabel = UILabel()
    let numberLabel = UILabel()
    
    let customSize: CGFloat = 14
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomView()
        
        setupCircleImgView()
        setupNumberLabel()
        setupTextLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(imgViewColor: UIColor, text: String, number: Int) {
        self.init(frame: .zero)
        circleImgView.backgroundColor = imgViewColor
        textLabel.text = text
        numberLabel.text = String(number)
    }
    
    private func setupCustomView() {
        self.backgroundColor = .systemGray
    }
    
    private func setupCircleImgView() {
        self.addSubview(circleImgView)
        
        circleImgView.translatesAutoresizingMaskIntoConstraints = false
        let yAnchor = circleImgView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let width = circleImgView.widthAnchor.constraint(equalToConstant: customSize)
        let height = circleImgView.heightAnchor.constraint(equalToConstant: customSize)
        NSLayoutConstraint.activate([yAnchor, width, height])
        
        circleImgView.layer.cornerRadius = customSize/2
    }
    
    private func setupNumberLabel() {
        self.addSubview(numberLabel)
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        let right = numberLabel.rightAnchor.constraint(equalTo: self.rightAnchor)
        let yAnchor = numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let height = numberLabel.heightAnchor.constraint(equalToConstant: 32)
        let width = numberLabel.widthAnchor.constraint(equalToConstant: 20)
        NSLayoutConstraint.activate([right, yAnchor, height, width])
        
        numberLabel.backgroundColor = .blue
        numberLabel.textColor = UIColor(red: 184/255.0, green: 184/255.0, blue: 184/255.0, alpha: 1)
        numberLabel.font = .boldSystemFont(ofSize: 30)
        numberLabel.textAlignment = .center
    }
    
    private func setupTextLabel() {
        self.addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        let left = textLabel.leftAnchor.constraint(equalTo: circleImgView.rightAnchor, constant: 10)
        let height = textLabel.heightAnchor.constraint(equalToConstant: 32)
        let width = textLabel.widthAnchor.constraint(equalToConstant: 150)
        let yAnchor = textLabel.centerYAnchor.constraint(equalTo: circleImgView.centerYAnchor)
        NSLayoutConstraint.activate([left, yAnchor, height, width])
        
        textLabel.backgroundColor = .white
        textLabel.textColor = UIColor(red: 184/255.0, green: 184/255.0, blue: 184/255.0, alpha: 1)
        textLabel.adjustsFontSizeToFitWidth = true
        
    }
}
