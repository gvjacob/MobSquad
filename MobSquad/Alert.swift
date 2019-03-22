//
//  Alert.swift
//  MobSquad
//
//  Created by Gino V. Jacob on 3/21/19.
//  Copyright © 2019 Gino V. Jacob. All rights reserved.
//

import Foundation
import Cocoa

class Alert {
    let label: NSTextField
    var timer: Timer?
    
    init(label: NSTextField) {
        self.label = label
    }
    
    func setAlert(message: String) {
        if label.stringValue != "" {
            timer?.invalidate()
        }
        
        label.stringValue = message

        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(removeLabel), userInfo: nil, repeats: false)
    }
    
    @objc func removeLabel() {
        label.stringValue = ""
    }
}
