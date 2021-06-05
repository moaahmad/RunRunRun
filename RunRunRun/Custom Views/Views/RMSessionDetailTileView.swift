//
//  RMSessionDetailTileView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/24/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSessionDetailTileView: UIView {
    private let mainStackView = UIStackView()
    
    private let textStackView = UIStackView()
    
    private let imageView = UIView()
    
    private let subtitleLabel = RMSecondaryTitleLabel(fontSize: 12,
                                                        fontWeight: .light,
                                                        color: .secondaryLabel)
    
    private let valueLabel = RMTitleLabel(textAlignment: .natural,
                                               fontSize: 22,
                                               color: .systemGreen,
                                               weight: .semibold)
    
    private let screenWidth = UIScreen.main.bounds.width
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        styleLayout()
    }
    
    convenience init(title: String, value: String) {
        self.init(frame: .zero)
        subtitleLabel.text = title
        valueLabel.text = value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI Layout
extension RMSessionDetailTileView {
    private func styleLayout() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 20
        
        imageView.backgroundColor = .white
        imageView.makeCircular()
    }
    
    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        configureStackViews()
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            // Cell
            heightAnchor.constraint(equalToConstant: 80),
            widthAnchor.constraint(equalToConstant: (screenWidth - 24 - 20) / 2),
            
            // MainStackView
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func configureStackViews() {
        // TextStackView
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.distribution = .fill
        textStackView.spacing = 2
        
        textStackView.addArrangedSubview(valueLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        
        // MainStackView
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.spacing = 12
        
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(textStackView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
