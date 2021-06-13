//
//  SessionUtilities.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 7/1/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

public class SessionUtilities {
    static func calculateAveragePace(time seconds: Int, meters: Double) -> String {
        guard meters > 0 else { return "0'00\"" }
        var pace = 0.0
        let kilometers = meters / 1000
        pace = (Double(seconds) / kilometers)
        let pacePerKm = pace.formatToAvgPaceString()
        return pacePerKm
    }
}
