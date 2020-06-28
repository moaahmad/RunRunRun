//
//  Double + Extensions.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/28/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import Foundation

extension Double {
    func metersToMiles(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ((self / 1609.34) * divisor).rounded() / divisor
    }
    
    func metersRounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
