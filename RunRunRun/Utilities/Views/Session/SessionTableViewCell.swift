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
    @IBOutlet weak var sessionType: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
