//
//  LiveActivityViewController.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 6/28/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class LiveActivityViewController: BaseViewController {
    // MARK: - Properties

    var viewModel: LiveActivityViewModeling

    private var buttonViewBottomConstraint: NSLayoutConstraint?

    private lazy var sessionDetailView = RMSessionDetailView()
    private lazy var pausedSessionView = RMPausedSessionViewController()
    private lazy var buttonView = RMSessionButtonStackView()

    init(viewModel: LiveActivityViewModeling = LiveActivityViewModel()) {
        self.viewModel = viewModel
        super.init()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        configureLayout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startActivity()
    }
}

extension LiveActivityViewController {
    func setupBindings() {
        viewModel.didUpdateDuration = { [weak self] duration in
            DispatchQueue.main.async {
                self?.sessionDetailView.durationView.valueLabel.text = duration
            }
        }

        viewModel.didUpdateDistance = { [weak self] distance in
            DispatchQueue.main.async {
                self?.sessionDetailView.distanceView.valueLabel.text = distance

            }
        }

        viewModel.didUpdatePace = { [weak self] pace in
            DispatchQueue.main.async {
                self?.sessionDetailView.averagePaceView.valueLabel.text = pace
            }
        }
    }
}

// MARK: - Pause & Play

extension LiveActivityViewController {
    private func didPauseActivity() {
        viewModel.activityDidPause()

        view.backgroundColor = .white
        sessionDetailView.removeFromSuperview()
        statusBarEnterDarkBackground()
        configurePauseSessionView()
        buttonView.pausePlayButton.setImage(name: "play.fill")
    }
    
    private func didPlayActivity() {
        viewModel.activityDidPlay()

        view.backgroundColor = .systemGreen
        pausedSessionView.view.removeFromSuperview()
        statusBarEnterLightBackground()
        configureSessionDetailView()
        buttonView.pausePlayButton.setImage(name: "pause.fill")
    }
}

// MARK: - Button Actions

extension LiveActivityViewController {
    @objc private func didTapPauseButton() {
        viewModel.pauseDidTap()
        animateButtonViewLayout()
        viewModel.isActivityPaused ? didPauseActivity() : didPlayActivity()
    }
    
    @objc private func didTapFinishButton() {
        removePausedView { [weak self] in
            self?.viewModel.finishButtonDidTap()
        }
    }

    private func removePausedView(completion: @escaping () -> Void) {
        buttonView.finishButton.isEnabled = false
        pausedSessionView.view.removeFromSuperview()
        completion()
    }
}

// MARK: - Configure UI Layout

private extension LiveActivityViewController {
    func configureLayout() {
        configureButtonView()
        configureSessionDetailView()
    }

    func configureSessionDetailView() {
        view.addSubview(sessionDetailView)
        NSLayoutConstraint.activate([
            sessionDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sessionDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            sessionDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }

    func configurePauseSessionView() {
        pausedSessionView.addRouteToMap(coordinateLocations: viewModel.locations)
        addChild(pausedSessionView)
        didMove(toParent: self)
        view.addSubview(pausedSessionView.view)
        NSLayoutConstraint.activate([
            pausedSessionView.view.topAnchor.constraint(equalTo: view.superview!.topAnchor),
            pausedSessionView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pausedSessionView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pausedSessionView.view.bottomAnchor.constraint(equalTo: buttonView.topAnchor, constant: -20)
        ])
    }

    func configureButtonView() {
        view.addSubview(buttonView)

        buttonView.pausePlayButton.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        buttonView.finishButton.isHidden = !viewModel.isActivityPaused

        buttonView.pausePlayButton.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
        buttonView.finishButton.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)

        buttonViewBottomConstraint = buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -68)
        NSLayoutConstraint.activate([
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonViewBottomConstraint!
        ])
    }

    func animateButtonViewLayout() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            let isPaused = self.viewModel.isActivityPaused
            self.buttonView.pausePlayButton.transform = isPaused ?
                CGAffineTransform(scaleX: 1, y: 1) : CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.buttonViewBottomConstraint?.constant = isPaused ? -8 : -68
            self.buttonView.finishButton.transform = isPaused ?
                CGAffineTransform(scaleX: 1, y: 1) : CGAffineTransform(scaleX: 0, y: 0)
            self.buttonView.hideShowFinishButton(isPaused)
        })
    }
}
