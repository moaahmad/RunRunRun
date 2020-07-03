//
//  CoreDataManager.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/1/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit
import CoreData

struct CoreDataManager: LocalPersistence {
    private let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext

    func save(duration: Int, distance: Double, pace: Double, startDateTime: Date) {
        let savedRun = Run(context: context)
        savedRun.duration = Int32(duration)
        savedRun.distance = distance
        savedRun.pace = pace
        savedRun.startDateTime = startDateTime
        savedRun.finishDateTime = Date()
        
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
        } catch  {
            debugPrint(error.localizedDescription)
            return runs
        }
    }
    
    func delete(_ runs: [Run], at index: Int) {
        context.delete(runs[index])
        
        do {
            try context.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
