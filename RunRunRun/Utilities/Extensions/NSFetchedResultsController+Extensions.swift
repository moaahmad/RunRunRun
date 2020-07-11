//
//  NSFetchedResultsController+Extensions.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/10/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import CoreData

extension NSFetchedResultsController where ResultType == Run {
    func runsOrderedByDate() -> [Run] {
        let fetchedRuns = self.fetchedObjects ?? []
        return fetchedRuns.sorted { (runA, runB) -> Bool in
            guard let startTimeA = runA.startDateTime,
                let startTimeB = runB.startDateTime else { return false }
            return startTimeA > startTimeB
        }
    }
}
