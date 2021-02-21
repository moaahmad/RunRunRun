//
//  Run.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 21/2/21.
//  Copyright © 2021 Ahmad, Mohammed. All rights reserved.
//
import Foundation

protocol Activity {
    var distance: Double { get set }
    var duration: Int32 { get set }
    var pace: Double { get set }
    var finishDateTime: Date? { get set }
    var startDateTime: Date? { get set }
    var id: UUID? { get set }
    var locations: NSSet? { get set }
}

extension Run: Activity { }
