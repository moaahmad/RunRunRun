//
//  UITableView+Extensions.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/24/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

extension UITableView {
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }

    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }

    func scrollToTop() {
        let topRow = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: topRow,
                              at: .top,
                              animated: true)
    }
}
