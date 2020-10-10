//
//  RMSummaryDetailStackView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 10/10/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RMSummaryDetailStackView: UIStackView {
    
    let imageView = UIImageView()
    
    let valueLabel = RMTitleLabel(textAlignment: .center,
                                  fontSize: 19,
                                  color: .label,
                                  weight: .semibold)
    
    let titleLabel = RMSecondaryTitleLabel(fontSize: 14,
                                           fontWeight: .light,
                                           color: .secondaryLabel,
                                           textAlignment: .center)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        styleLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage, value: String, title: String) {
        self.init(frame: .zero)
        imageView.image = image.withTintColor(.systemOrange)
        valueLabel.text = value
        titleLabel.text = title
    }
}

extension RMSummaryDetailStackView {
    private func configureLayout() {
        axis = .vertical
        distribution = .fill
        alignment = .center
        spacing = 12
        
        let textStackView = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .center
        textStackView.spacing = 4
        
        addArrangedSubview(imageView)
        addArrangedSubview(textStackView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func styleLayout() {
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 35),
            imageView.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
}
