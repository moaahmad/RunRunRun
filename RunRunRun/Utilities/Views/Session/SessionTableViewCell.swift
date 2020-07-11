//
//  SessionTableViewCell.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/2/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class SessionTableViewCell: UITableViewCell {
    @IBOutlet weak var sessionImageView: UIImageView! {
        didSet {
            sessionImageView.makeCircular()
        }
    }
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var sessionType: UILabel! {
        didSet {
            sessionType.text = "Run"
        }
    }
    @IBOutlet weak var dateLabel: UILabel!

    func configureSession(run: Run) {
        guard let startDateTime = run.startDateTime else { return }
        self.dateLabel.text = DateFormatter.shortStyleDateFormatter.string(from: startDateTime)
        self.distanceLabel.text = run.distance.convertMetersIntoKilometers() + " km"
    }
}
