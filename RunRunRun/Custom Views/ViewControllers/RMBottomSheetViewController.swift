//
//  RMBottomSheetViewController.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/23/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMBottomSheetViewController: UIViewController {
    private enum State {
        case partial
        case full
    }
    
    private enum Constant {
        static let fullViewYPosition: CGFloat = 100
        static var partialViewYPosition: CGFloat { UIScreen.main.bounds.height * 0.55 }
    }
    
    let notchView = UIView()
    var run: Run!
    
    init(run: Run) {
        super.init(nibName: nil, bundle: nil)
        self.run = run
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
        self.moveView(state: .partial)
        configureLayout()
    }
    
    private func moveView(state: State) {
        let yPosition = state == .partial ? Constant.partialViewYPosition : Constant.fullViewYPosition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
    }

    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY
        
        if (minY + translation.y >= Constant.fullViewYPosition) && (minY + translation.y <= Constant.partialViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.allowUserInteraction], animations: {
                let state: State = recognizer.velocity(in: self.view).y >= 0 ? .partial : .full
                self.moveView(state: state)
            })
        }
    }
}

// MARK: - Configure UI Layout
extension RMBottomSheetViewController {
    private func configureLayout() {
        roundViews()
        configureNotchView()
        configureSessionDetailVC()
    }
    
    private func configureSessionDetailVC() {
        let sessionDetailVC = RMSessionDetailViewController(title: "RUN", run: run)
        addChild(sessionDetailVC)
        view.addSubview(sessionDetailVC.view)
        sessionDetailVC.didMove(toParent: self)
        NSLayoutConstraint.activate([
            sessionDetailVC.view.topAnchor.constraint(equalToSystemSpacingBelow: notchView.bottomAnchor, multiplier: 2),
            sessionDetailVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            sessionDetailVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            sessionDetailVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }
    
    private func configureNotchView() {
        notchView.backgroundColor = .secondaryLabel
        notchView.layer.cornerRadius = 2
        notchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notchView)
        NSLayoutConstraint.activate([
            notchView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            notchView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notchView.widthAnchor.constraint(equalToConstant: 40),
            notchView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    private func roundViews() {
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
    }
}
