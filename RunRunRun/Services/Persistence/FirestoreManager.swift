//
//  FirestoreManager.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 21/2/21.
//  Copyright © 2021 Ahmad, Mohammed. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FirestoreManager: LocalPersistence {
    func save(duration: Int, distance: Double, pace: Double, startDateTime: Date, locations: [Location]) { }
    
    func readAll() throws -> [Run] {
        []
    }

    func delete(_ activity: Run) { }
}
