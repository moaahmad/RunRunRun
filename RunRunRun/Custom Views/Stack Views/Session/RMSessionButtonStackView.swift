//
//  RMSessionButtonView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 9/10/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSessionButtonStackView: UIStackView {
    
    let pausePlayButton = RMPausePlayButton()
    let finishButton = RMActionButton(title: "FINISH")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RMSessionButtonStackView {
    func hideShowFinishButton(_ isPaused: Bool) {
            finishButton.isHidden = !isPaused
        }
    
    private func configure() {
        axis = .vertical
        distribution = .fill
        alignment = .center
        spacing = 16
        
        addArrangedSubview(pausePlayButton)
        addArrangedSubview(finishButton)
        
        configurePausePlayButton()
        configureFinishButton()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configurePausePlayButton() {
        NSLayoutConstraint.activate([
            pausePlayButton.heightAnchor.constraint(equalToConstant: 80),
            pausePlayButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureFinishButton() {
        NSLayoutConstraint.activate([
            finishButton.heightAnchor.constraint(equalToConstant: 120),
            finishButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
