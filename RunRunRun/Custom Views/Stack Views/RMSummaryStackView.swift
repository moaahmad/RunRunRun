//
//  RMSummaryStackView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 10/9/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RMSummaryStackView: UIStackView {
    
    let totalDistanceStackView = RMSummaryDetailStackView(image: UIImage(named: "run")!,
                                                                       value: "100000",
                                                                       title: "Kilometres")
    
    let totalDurationStackView = RMSummaryDetailStackView(image: UIImage(named: "timer")!,
                                                                       value: "36:34:34", 
                                                                       title: "Time")

    let totalAveragePaceStackView = RMSummaryDetailStackView(image: UIImage(named: "run")!,
                                                                          value: "07'34\"",
                                                                          title: "Avg. Pace")
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    convenience init(<#parameters#>) {
//        <#statements#>
//    }
    
    private func configureLayout() {
        axis = .horizontal
        distribution = .fillEqually
        alignment = .center
        spacing = 8
        
        addArrangedSubview(totalDistanceStackView)
        addArrangedSubview(totalDurationStackView)
        addArrangedSubview(totalAveragePaceStackView)
        
        totalDistanceStackView.translatesAutoresizingMaskIntoConstraints = false
        totalDurationStackView.translatesAutoresizingMaskIntoConstraints = false
        totalAveragePaceStackView.translatesAutoresizingMaskIntoConstraints = false
    }
}
