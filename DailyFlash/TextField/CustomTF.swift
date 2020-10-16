//
//  CustomTextField.swift
//  DailyFlash
//
//  Created by Alexey Kirpichnikov on 2020/10/7.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class CustomTF: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .customLightGray
        layer.cornerRadius = 20
    }

}
