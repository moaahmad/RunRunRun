//
//  DateFormatter + Extensions.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/5/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import Foundation

extension DateFormatter {
    /// Returns a short style date formatter in user's locale.  E.g., 7/11/2016
    static let shortStyleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    /// Returns a short style date/time formatter in user's locale.  E.g., 07/11/2016, 16:37
    static let shortStyleTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    /// Returns a short style date formatter in user's locale.  E.g., Sat 11 Jul
    static let mediumStyleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d MMM"
        return formatter
    }()
}
