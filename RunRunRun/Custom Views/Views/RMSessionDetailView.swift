//
//  RMSessionDetailView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/26/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSessionDetailView: UIView {
    static let viewHeight = UIScreen.main.bounds.height * 0.5
    
    let averagePaceView = RMSessionDetailSmallStackView(value: "--'--\"", subtitle: "Pace")
    let durationView = RMSessionDetailSmallStackView(value: "00:00", subtitle: "Time")
    let distanceView = RMSessionDetailLargeStackView(value: "0.00", subtitle: "Kilometres")
    
    let topStackView = UIStackView()
    let mainStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI Layout
extension RMSessionDetailView {
    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        configureTopStackView()
        configureMainStackView()
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            topStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            distanceView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: RMSessionDetailView.viewHeight)
        ])
    }
    
    private func configureTopStackView() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .horizontal
        topStackView.alignment = .lastBaseline
        topStackView.distribution = .fillEqually
        
        topStackView.addArrangedSubview(averagePaceView)
        topStackView.addArrangedSubview(durationView)
    }

    private func configureMainStackView() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(distanceView)
    }
}
