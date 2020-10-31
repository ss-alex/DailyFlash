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
        setupTF()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTF() {
        autocorrectionType = .no
        returnKeyType = .done
    }
    
    private func setupUI() {
        backgroundColor = .customLightGray
        layer.cornerRadius = 20
        
        font = UIFont(name: "Mada-Regular", size: 26)
        textColor = UIColor.customWhite
        
        self.setLeftPaddingPoints(6)
        self.setRightPaddingPoints(6)
        
        layer.shadowColor = UIColor.systemBackground.cgColor
        layer.shadowRadius = 4 /// it's the 'blur' in Figma
        layer.shadowOffset = CGSize(width: 0, height: 4) /// width is 'x', height is 'y'
        layer.shadowOpacity = 0.8 /// how transperent or bold the shadow is
    }

}
