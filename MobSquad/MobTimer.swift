//
//  MobTimer.swift
//  MobSquad
//
//  Created by Gino V. Jacob on 3/13/19.
//  Copyright © 2019 Gino V. Jacob. All rights reserved.
//


import Foundation


class MobTimer {
    var timer: Timer?
    var minutes: Int
    var seconds: Int {
        didSet {
            NotificationCenter.default.post(name: .didChangeTime, object: nil)
        }
    }
    
    var inProgress = false
    
    init(minutes: Int) {
        self.minutes = minutes
        self.seconds = self.minutes * 60
    }
    
    @objc func time() -> String {
        return formatTime(seconds: self.seconds)
    }
    
    @objc func decrement() {
        if seconds > 0 { seconds -= 1 }
    }
    
    @objc func play() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrement), userInfo: nil, repeats: true)
        inProgress = true
    }
    
    /**
     * Pause the timer.
     */
    @objc func pause() {
        timer?.invalidate()
        inProgress = false
    }
    
    /**
     * Stop the timer and reset to preset minutes.
     */
    @objc func stop() {
        pause()
        seconds = minutes * 60
    }
    
    /**
     * Reset the timer to given number of minutes.
     */
    @objc func resetTo(minutes: Int) {
        self.minutes = minutes
        stop()
    }
}

func formatTime(seconds: Int) -> String {
    let mins = seconds / 60
    let secs = seconds % 60
    return String(format: "%02i:%02i", mins, secs)
}
