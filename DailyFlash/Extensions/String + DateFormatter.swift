//
//  String + DateFormatter.swift
//  DailyFlash
//
//  Created by Лена Мырленко on 2020/8/28.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import Foundation

extension String {
    
    //[Need to implement this method later to optimize spaghetti code]
    
    func convertStringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }
    
}
