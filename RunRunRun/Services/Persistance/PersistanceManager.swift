//
//  PersistanceManager.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/1/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import Foundation

public struct PersistenceManager {
    public static var store: LocalPersistence = CoreDataManager()
}
