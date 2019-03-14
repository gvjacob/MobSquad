//
//  MobberManager.swift
//  MobSquad
//
//  Created by Gino V. Jacob on 3/13/19.
//  Copyright © 2019 Gino V. Jacob. All rights reserved.
//

import Foundation

/**
 * Manage the mobber list.
 */
class MobberManager {
    /**
     * List of mobbers with their names and whether they are enabled in the rotation.
     */
    var mobbers: Array<(name: String, enabled: Bool)>
    var currentMobber: String
    var currentMobberIndex: Int {
        didSet {
            currentMobber = mobbers[currentMobberIndex].name
            NotificationCenter.default.post(name: .didChangeMobber, object: nil)
        }
    }
    
    init(mobbers: Array<String>) {
        self.mobbers = mobbers.map { ($0, true) }
        currentMobberIndex = 0
        currentMobber = self.mobbers[currentMobberIndex].name
    }
    
    /**
     * Add a new mobber.
     */
    func addMobber(name: String, enabled: Bool = true) {
        mobbers.append((name, enabled))
    }
    
    /**
     * Remove the given mobber.
     */
    func removeMobber(name: String) {
        mobbers = mobbers.filter { $0.name != name }
    }
    
    /**
     * Enable or disable given mobber.
     */
    func toggleMobber(name: String) {
        mobbers = mobbers.reduce([]) { arr, mobber in arr + [( mobber.name != name ? mobber : (mobber.name, !mobber.enabled))]}
    }
    
    func getNextMobberName() -> String {
        return mobbers[(currentMobberIndex + 1) % mobbers.count].name
    }
    
    func nextMobber() {
        currentMobberIndex = (currentMobberIndex + 1) % mobbers.count

    }
}
