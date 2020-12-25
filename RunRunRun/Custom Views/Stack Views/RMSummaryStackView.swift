//
//  RMSummaryStackView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 10/9/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RMSummaryStackView: UIStackView {
    let totalDistanceStackView = RMSummaryDetailStackView(value: "--",
                                                          title: "Kilometres")
    
    let totalDurationStackView = RMSummaryDetailStackView(value: "--:--:--",
                                                          title: "Time")

    let totalAveragePaceStackView = RMSummaryDetailStackView(value: "--'--\"",
                                                             title: "Avg. Pace")
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        totalDistanceStackView.translatesAutoresizingMaskIntoConstraints = false
        totalDurationStackView.translatesAutoresizingMaskIntoConstraints = false
        totalAveragePaceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        axis = .horizontal
        distribution = .fillEqually
        alignment = .center
        spacing = 8
        
        addArrangedSubview(totalDistanceStackView)
        addArrangedSubview(totalDurationStackView)
        addArrangedSubview(totalAveragePaceStackView)
    }
}
