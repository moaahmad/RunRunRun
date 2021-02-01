//
//  SessionTableViewCell.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/2/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class SessionTableViewCell: UITableViewCell {
    static let reuseID = "SessionTableViewCell"
    
    private(set) var sessionImage = UIImageView()
    
    private(set) var distanceLabel = RMTitleLabel(textAlignment: .center,
                                                  fontSize: 21,
                                                  color: .systemGreen,
                                                  weight: .semibold)
    
    private(set) var dateLabel = RMSecondaryTitleLabel(fontSize: 12,
                                                       fontWeight: .light,
                                                       color: .secondaryLabel)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        styleLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSession(run: Run) {
        guard let startDateTime = run.startDateTime else { return }
        configureDateFormat(date: startDateTime)
        self.distanceLabel.text = run.distance.convertMetersIntoKilometers() + " km"
    }
    
    private func configureDateFormat(date: Date) {
        if Calendar.current.isDateInToday(date) {
            dateLabel.text = DateFormatter.timeStyleDateFormatter.string(for: date)
        } else if Calendar.current.isDateInYesterday(date) {
            dateLabel.text = "Yesterday"
        } else if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfMonth) {
            dateLabel.text = DateFormatter.dayStyleDateFormatter.string(for: date)
        } else {
            self.dateLabel.text = DateFormatter.shortStyleDateFormatter.string(from: date)
        }
    }
}

extension SessionTableViewCell {
    private func configureLayout() {
        addSubview(sessionImage)
        addSubview(distanceLabel)
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60),
            
            sessionImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            sessionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            sessionImage.heightAnchor.constraint(equalToConstant: 25),
            sessionImage.widthAnchor.constraint(equalToConstant: 25),
            
            distanceLabel.leadingAnchor.constraint(equalTo: sessionImage.trailingAnchor, constant: 8),
            distanceLabel.centerYAnchor.constraint(equalTo: sessionImage.centerYAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34),
            dateLabel.centerYAnchor.constraint(equalTo: sessionImage.centerYAnchor)
        ])
    }
    
    private func styleLayout() {
        sessionImage.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sessionImage.image = UIImage(named: "run")?
            .withTintColor(.label)
        sessionImage.contentMode = .scaleAspectFit
    }
}
