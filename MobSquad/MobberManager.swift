//
//  MobberManager.swift
//  MobSquad
//
//  Created by Gino V. Jacob on 3/13/19.
//  Copyright © 2019 Gino V. Jacob. All rights reserved.
//

import Foundation

class MobberManager {
    
    var mobbers: [(name: String, enabled: Bool)] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateMobbers, object: nil)
        }
    }
    
    var currentIndex: Int {
        didSet {
            NotificationCenter.default.post(name: .didChangeMobber, object: nil)
        }
    }
    
    init(mobbers: [String]) {
        self.mobbers = mobbers.map { ($0, true) }
        currentIndex = 0
    }
    
    func next() {
        if let nextIndex = getNextIndex() {
            currentIndex = nextIndex
        }
    }
    
    func getCurrentMobber() -> (name: String, enabled: Bool)? {
        return getMobberAt(index: currentIndex)
    }

    func getNextMobber() -> (name: String, enabled: Bool)? {
        if let nextIndex = getNextIndex() {
            return getMobberAt(index: nextIndex)
        }
        return nil
    }
    
    func addMobber(name: String, enabled: Bool = true) {
        mobbers.append((name, enabled))
    }
    
    func removeMobber(name: String) {
        mobbers = mobbers.filter { $0.name != name }
    }
    
    func toggleMobber(name: String) {
        mobbers = mobbers.reduce([]) { arr, mobber in arr + [( mobber.name != name ? mobber : (mobber.name, !mobber.enabled))]}
    }
    
    private func getMobberAt(index: Int) -> (name: String, enabled: Bool)? {
        return index >= mobbers.count ? nil : mobbers[index]
    }
    
    private func getNextIndex() -> Int? {
        return mobbers.isEmpty ? nil : (currentIndex + 1) % mobbers.count
    }
}
