//
//  Date+Extensions.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 10/5/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import Foundation

extension Date {
    func firstDayOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
}
