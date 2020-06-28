//
//  RunSession.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/28/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import Foundation

final class RunSession {
    
    private var timer: Timer
    private var counter = 0
    weak var delegate: UpdateDurationDelegate?
    
    init(timer: Timer, delegate: UpdateDurationDelegate?) {
        self.timer = Timer()
        self.delegate = delegate
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateCounter),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func pause() {
        timer.invalidate()
    }
    
    @objc func updateCounter() {
        counter += 1
        delegate?.updateDurationLabel(with: counter)
    }
}
