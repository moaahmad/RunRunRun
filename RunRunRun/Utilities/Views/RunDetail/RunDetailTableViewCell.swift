//
//  SessionDetailTableViewCell.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/2/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RunDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var runImageView: UIImageView! {
        didSet {
            runImageView.makeCircular()
        }
    }
    @IBOutlet weak var runTitleLabel: UILabel! {
        didSet {
            runTitleLabel.text = "Run"
        }
    }
    @IBOutlet weak var runDateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    
    func configureRunDetailCell(run: Run) {
        self.runDateLabel.text = "\(String(describing: run.startDateTime)) - \(String(describing: run.finishDateTime))"
        self.distanceLabel.text = String(run.distance)
        self.durationLabel.text = String(run.duration)
        self.averagePaceLabel.text = SessionUtilities.calculateAveragePace(time: Int(run.duration), meters: run.distance)
    }
}
