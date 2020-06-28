//
//  Int + Extensions.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/28/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import Foundation

extension Int {
    func formatDuration() -> String {
        let durationHours = self / 3600
        let durationMinutes = (self % 3600) / 60
        let durationSeconds = (self % 3600) % 60
        
        if durationSeconds < 0 {
            return "00:00:00"
        } else {
            if durationHours == 0 {
                return String(format: "%02d:%02d",
                              durationMinutes,
                              durationSeconds)
            } else {
                return String(format: "%02d:%02d:%02d",
                              durationHours,
                              durationMinutes,
                              durationSeconds)
            }
        }
    }
    
    func formatPace() -> String {
        return ""
    }
}
