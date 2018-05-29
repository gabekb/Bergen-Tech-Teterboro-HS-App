//
//  DateConverterExtension.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/22/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import Foundation
extension Date {
    static func getFormattedDate(d: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +hhmm"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        let date: Date? = dateFormatterGet.date(from: d)
        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!);
    }
}
