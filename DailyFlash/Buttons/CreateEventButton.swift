//
//  CreateEventButton.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/10/1.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import Foundation
import UIKit

final class CreateEventButton: UIButton  {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .customLightGray
        layer.cornerRadius = 20
        
        setTitle("Create an event", for: .normal)
        setTitleColor(.customWhiteTitle, for: .normal)
        titleLabel?.font = UIFont(name: "Mada-Bold", size: 24)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 4 /// it's the 'blur' in Figma
        layer.shadowOffset = CGSize(width: 0, height: 4) /// width is 'x', height is 'y'
        layer.shadowOpacity = 0.8 /// how transperent or bold the shadow is
    }
}
