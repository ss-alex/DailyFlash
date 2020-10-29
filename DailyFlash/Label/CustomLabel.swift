//
//  CustomLabel.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/10/7.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textColor: UIColor, text: String) {
        self.init(frame: .zero)
        self.textColor = textColor
        self.text = text
    }
    
    private func setupUI() {
        self.font = UIFont(name: "Mada-Regular", size: 26)
        self.layer.cornerRadius = 20
    }

}
