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
    
    func readAll() throws -> [Run] {
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

    func delete(_ activity: Run) {
        context.delete(activity)

        do {
            try context.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
