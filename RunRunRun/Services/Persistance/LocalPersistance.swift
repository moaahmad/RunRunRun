//
//  LocalPersistance.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/1/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import Foundation
import CoreData

public protocol LocalPersistence {
    // CRUD database operations
    func save(duration: Int, distance: Double, pace: Double, startDateTime: Date)
    mutating func setupFetchedRunsController() -> NSFetchedResultsController<Run>
    func readAll() -> [Run]?
    func delete(at indexPath: IndexPath)
}
