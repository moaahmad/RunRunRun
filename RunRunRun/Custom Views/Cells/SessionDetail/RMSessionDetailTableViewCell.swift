//
//  RMSessionDetailTableViewCell.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/24/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RMSessionDetailTableViewCell: UITableViewCell {
    static let reuseID = "SessionDetailCell"
    
    private let mainStackView = UIStackView()
    private let firstStackView = UIStackView()
    private let secondStackView = UIStackView()
    
    private var distanceTileView: RMSessionDetailTileView!
    private var averagePaceTileView: RMSessionDetailTileView!
    private var timeTileView: RMSessionDetailTileView!
    
    func configureCell(forRun run: Run) {
        distanceTileView = RMSessionDetailTileView(title: "Kilometres",
                                                   value: run.distance.convertMetersIntoKilometers())
        
        averagePaceTileView = RMSessionDetailTileView(title: "Avg. Pace",
                                                      value: SessionUtilities.calculateAveragePace(time: Int(run.duration),
                                                                                                   meters: run.distance))
        
        timeTileView = RMSessionDetailTileView(title: "Time",
                                               value: run.duration.formatToTimeString())
        
        configureLayout()
    }
}

// MARK: - Configure UI Layout
extension RMSessionDetailTableViewCell {
    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        configureStackViews()
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    private func configureStackViews() {
        // FirstStackView
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        
        firstStackView.axis = .horizontal
        firstStackView.alignment = .lastBaseline
        firstStackView.distribution = .fillEqually
        firstStackView.spacing = 20
        
        firstStackView.addArrangedSubview(distanceTileView)
        firstStackView.addArrangedSubview(averagePaceTileView)
        
        // SecondStackView
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        
        secondStackView.axis = .horizontal
        secondStackView.alignment = .lastBaseline
        secondStackView.distribution = .fillProportionally
        secondStackView.spacing = 20
        
        secondStackView.addArrangedSubview(timeTileView)
        
        // MainStackView
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .leading
        mainStackView.distribution = .fill
        mainStackView.spacing = 20
        
        mainStackView.addArrangedSubview(firstStackView)
        mainStackView.addArrangedSubview(secondStackView)
    }
}
