//
//  ActivityHistoryViewModel.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 21/2/21.
//  Copyright © 2021 Ahmad, Mohammed. All rights reserved.
//

import UIKit
import CoreData

protocol ActivityHistoryViewModeling {
    var coordinator: Coordinator? { get set }
}

final class ActivityHistoryViewModel {
    weak var coordinator: Coordinator?

    private var fetchedRuns: NSFetchedResultsController<Run>!
    private var runs = [Run]()
    var sections = [GroupedSection<Date, Run>]()
}
