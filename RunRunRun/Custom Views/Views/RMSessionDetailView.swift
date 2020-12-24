//
//  RMSessionDetailView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/23/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RMSessionDetailView: UIView {
    let titleStackView = UIStackView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        styleView()
    }
    
    convenience init(title: String, subtitle: String) {
        self.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func styleView() {
        titleLabel.textColor = .systemGreen
        titleLabel.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        
    }
    
    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleStackView)
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill
        titleStackView.alignment = .lastBaseline
        titleStackView.spacing = 6
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            titleStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1)
        ])
    }
}
