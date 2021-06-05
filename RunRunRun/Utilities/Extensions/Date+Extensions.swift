//
//  Date+Extensions.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 10/5/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import Foundation

extension Date {
    func firstDayOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
}
