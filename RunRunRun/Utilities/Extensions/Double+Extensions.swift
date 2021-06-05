//
//  Double + Extensions.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 6/28/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import Foundation

extension Double {
    func metersToMiles(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ((self / 1609.34) * divisor).rounded() / divisor
    }
    
    func convertMetersIntoKilometers() -> String {
        let kilometers = self / 1000
        let result = String(format: "%.2f", kilometers)
        return result
    }
    
    func formatToAvgPaceString() -> String {
        let durationHours = self / 3600
        let durationMinutes = (Int(self) % 3600) / 60
        let durationSeconds = (Int(self) % 3600) % 60
        
        guard durationHours > 0 else { return "" }
        return String(format: "%02d'%02d\"",
                      durationMinutes,
                      durationSeconds)
    }
}
