//
//  RepeatingTimer.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 6/28/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RepeatingTimer {
    enum State {
        case suspended
        case resumed
    }

    private let timeInterval: TimeInterval
    var counter = 0
    private var state: State = .suspended
    private var eventHandler: (() -> Void)?
    weak var delegate: UpdateDurationDelegate?

    init(timeInterval: TimeInterval, delegate: UpdateDurationDelegate?) {
        self.timeInterval = timeInterval
        self.delegate = delegate
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
            self?.updateCounter()
        })
        return t
    }()

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }

    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    func suspend() {
        if state == .suspended {
            state = .resumed
            timer.resume()
        } else {
            state = .suspended
            timer.suspend()
        }
    }
    
    private func updateCounter() {
        counter += 1
        self.delegate?.updateDuration(with: self.counter)
    }
}
