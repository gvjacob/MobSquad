//
//  MobTimer.swift
//  MobSquad
//
//  Created by Gino V. Jacob on 3/13/19.
//  Copyright © 2019 Gino V. Jacob. All rights reserved.
//


import Foundation

func formatTime(seconds: Int) -> String {
    let mins = seconds / 60
    let secs = seconds % 60
    return String(format: "%02i:%02i", mins, secs)
}


/**
 * Manage the mobbing timed sessions.
 */
class MobTimer {
    var timer: Timer?
    
    // Preset minutes per rotation
    var minutes: Int
    
    // Seconds left in rotation
    var seconds: Int {
        didSet {
            time = formatTime(seconds: seconds)
            NotificationCenter.default.post(name: .didChangeTime, object: nil)
        }
    }
    
    // Formatted time
    var time: String
    
    // Is timer in progress?
    var inProgress = false
    
    init(minutes: Int) {
        self.minutes = minutes
        self.seconds = self.minutes * 60
        self.time = formatTime(seconds: self.seconds)
    }
    
    /**
     * Decrement current seconds by given value and notify center.
     */
    @objc func decrement() {
        if seconds != 0 {
            seconds = seconds - 1
        }
    }
    
    /**
     * Play the timer.
     */
    
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
