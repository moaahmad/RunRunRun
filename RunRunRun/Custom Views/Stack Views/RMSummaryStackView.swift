//
//  RMSummaryStackView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 10/9/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSummaryStackView: UIStackView {

    lazy var totalDistanceStackView = RMSummaryDetailStackView(value: "0",
                                                               title: "Kilometres",
                                                               alignment: .leading)
    
    lazy var totalDurationStackView = RMSummaryDetailStackView(value: "00:00",
                                                               title: "Time",
                                                               alignment: .trailing)
        
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

        axis = .horizontal
        distribution = .fill
        alignment = .center
        
        addArrangedSubview(totalDistanceStackView)
        addArrangedSubview(UIView())
        addArrangedSubview(totalDurationStackView)
    }
}
