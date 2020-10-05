//
//  CreateEventButton.swift
//  DailyFlash
//
//  Created by Лена Мырленко on 2020/10/1.
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
    }
}
