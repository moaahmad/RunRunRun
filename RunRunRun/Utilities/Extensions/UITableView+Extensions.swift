//
//  UITableView+Extensions.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/24/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

extension UITableView {
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }

    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
