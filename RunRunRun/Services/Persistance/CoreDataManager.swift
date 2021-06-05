//
//  CoreDataManager.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 7/1/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit
import CoreData

struct CoreDataManager: LocalPersistence {
    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer.viewContext ?? .init(concurrencyType: .mainQueueConcurrencyType)
    }
    
    var fetchedResultsController: NSFetchedResultsController<Run>!
    
    mutating func setupFetchedRunsController() -> NSFetchedResultsController<Run> {
        let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "startDateTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: "runs")
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        return fetchedResultsController
    }

    func save(duration: Int,
              distance: Double,
              pace: Double,
              startDateTime: Date,
              locations: [Location]) {
        let savedRun = Run(context: context)
        savedRun.id = UUID()
        savedRun.duration = Int32(duration)
        savedRun.distance = distance
        savedRun.pace = pace
        savedRun.startDateTime = startDateTime
        savedRun.finishDateTime = Date()
        savedRun.locations = NSSet(array: locations)
        
        do {
            try context.save()
            print("Run Saved Successfully")
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func readAll() -> [Run]? {
        let fetchRequest = NSFetchRequest<Run>(entityName: "Run")
        var runs = [Run]()
        do {
            runs = try context.fetch(fetchRequest)
            return runs
        } catch {
            debugPrint(error.localizedDescription)
            return runs
        }
    }
    
    func delete(at indexPath: IndexPath) {
        let runToDelete = fetchedResultsController.object(at: indexPath)
        context.delete(runToDelete)
        
        do {
            try context.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
