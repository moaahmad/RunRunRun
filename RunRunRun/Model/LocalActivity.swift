//
//  LocalActivity.swift
//  RunRunRun
//
//  Created by Mo Ahmad on 06/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import Foundation

protocol ActivityRepresentable {
    var duration: Int? { get set }
    var distance: Double? { get set }
    var pace: Double? { get set }
    var startDateTime: Date? { get set }
    var locations: [Location]? { get set }
}

struct LocalActivity: ActivityRepresentable {
    var duration: Int?
    var distance: Double?
    var pace: Double?
    var startDateTime: Date?
    var locations: [Location]?
}
