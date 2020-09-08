//
//  SessionUtilities.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/1/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

public class SessionUtilities {
    static func calculateAveragePace(time seconds: Int, meters: Double) -> String {
        var pace = 0.0
        let kilometers = meters / 1000
        guard kilometers > 0 else { return "Calculating..." }
        pace = (Double(seconds) / kilometers)
        let pacePerKm = pace.formatToAvgPaceString()
        return pacePerKm
    }
}
