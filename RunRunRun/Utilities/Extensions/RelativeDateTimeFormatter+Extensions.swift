//
//  RelativeDateTimeFormatter+Extensions.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/25/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import Foundation

extension RelativeDateTimeFormatter {
    static let relativeStyleDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .full
        return formatter
    }()
}
