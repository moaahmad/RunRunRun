//
//  SessionDetailTableViewCell.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 7/2/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RunDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var runTitleLabel: UILabel! {
        didSet {
            runTitleLabel.text = "RUN"
        }
    }
    @IBOutlet weak var runDateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    
    func configureRunDetail(run: Run) {
        let startTime = DateFormatter.shortStyleTimeFormatter.string(from: run.startDateTime ?? Date())
        let endTime = DateFormatter.shortStyleTimeFormatter.string(from: run.finishDateTime ?? Date())
        self.runDateLabel.text = "\(startTime) - \(endTime)"
        self.distanceLabel.text = run.distance.convertMetersIntoKilometers()
        self.durationLabel.text = run.duration.formatToTimeString()
        self.averagePaceLabel.text = SessionUtilities.calculateAveragePace(time: Int(run.duration),
                                                                           meters: run.distance)
    }
}
