//
//  RMSummaryStackView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 10/9/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSummaryStackView: UIStackView {
    lazy var totalWorkoutsStackView = RMSummaryDetailStackView(value: "0",
                                                               title: "Workouts")

    lazy var totalDistanceStackView = RMSummaryDetailStackView(value: "0",
                                                               title: "Kilometres")
    
    lazy var totalDurationStackView = RMSummaryDetailStackView(value: "00:00",
                                                               title: "Time")
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        totalWorkoutsStackView.translatesAutoresizingMaskIntoConstraints = false
        totalDistanceStackView.translatesAutoresizingMaskIntoConstraints = false
        totalDurationStackView.translatesAutoresizingMaskIntoConstraints = false

        axis = .horizontal
        distribution = .fillEqually
        alignment = .center
        spacing = 8
        
        addArrangedSubview(totalWorkoutsStackView)
        addArrangedSubview(totalDistanceStackView)
        addArrangedSubview(totalDurationStackView)
    }
}
