//
//  AppDelegate.swift
//  MobSquad
//
//  Created by Gino V. Jacob on 3/13/19.
//  Copyright © 2019 Gino V. Jacob. All rights reserved.
//

import Cocoa

// Define notification events 
extension Notification.Name {
    // Mob timer did change time
    static let didChangeTime = Notification.Name("didChangeTime")

    // Mobber manager did change current mobber
    static let didChangeMobber = Notification.Name("didChangeMobber")
    
    // Mobber list is updated
    static let didUpdateMobbers = Notification.Name("didUpdateMobbers")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let userDefaults = UserDefaults.standard
    var mobbers: Array<String>
    var minutes: Int
    var shuffle: Bool
    
    // Settings UI
    
    // Status bar UI
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = NSMenu()
    let playPauseItem = NSMenuItem(title: "Play", action: #selector(AppDelegate.toggleTimer(_:)), keyEquivalent: "p")
    let resetItem = NSMenuItem(title: "Reset", action: #selector(AppDelegate.resetTimer(_:)), keyEquivalent: "r")
    let nextItem = NSMenuItem(title: "Next", action: #selector(AppDelegate.nextMobber(_:)), keyEquivalent: "n")
    let settingsItem = NSMenuItem(title: "Settings", action: #selector(AppDelegate.openSettings(_:)), keyEquivalent: "S")
    let quitItem = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    
    // Models
    var mobberManager: MobberManager
    var timer: MobTimer
    
    /* Grab user defaults and initialize models */
    override init() {
        userDefaults.register(defaults: ["mobbers": [],
                                         "minutes": 10,
                                         "shuffle": false])
        
        mobbers = userDefaults.stringArray(forKey: "mobbers") ?? []
        minutes = userDefaults.integer(forKey: "minutes")
        shuffle = userDefaults.bool(forKey: "shuffle")
        
        mobberManager = MobberManager(mobbers: self.mobbers)
        timer = MobTimer(minutes: self.minutes)
    }

    /* Register observers, construct base UI */
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidChangeTime(_:)), name: .didChangeTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidChangeMobber(_:)), name: .didChangeMobber, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidUpdateMobbers(_:)), name: .didUpdateMobbers, object: nil)

        updateStatusItemTitle(title: getTitle())
        constructMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        userDefaults.set(timer.minutes, forKey: "minutes")
        
        let mobberNames = mobberManager.mobbers.map { $0.name }
        userDefaults.set(mobberNames, forKey: "mobbers")
    }
    
    
    /* Update the status item's title with given title */
    func updateStatusItemTitle(title: String) {
        if let button = statusItem.button {
            button.title = title
        }
    }
    
    func handleTimeout() {
        timer.stop()
        let buttonPressed = timeoutDialog().rawValue
        switch buttonPressed {
        case 1000:
            mobberManager.next()
            timer.play()
        case 1001:
            mobberManager.next()
            mobberManager.next()
        default:
            mobberManager.next()
            timer.play()
        }
    }
    
    @objc func onDidUpdateMobbers(_ notification: Notification) {
        updateStatusItemTitle(title: getTitle())
        updateMenu()
    }

    /* Update status item title, and show alert if timeout */
    @objc func onDidChangeTime(_ notification: Notification) {
        updateStatusItemTitle(title: getTitle())
        updateMenu()
        if timer.seconds == 0 { handleTimeout() }
    }
    
    @objc func onDidChangeMobber(_ notification: Notification) {
        updateStatusItemTitle(title: getTitle())
        updateMenu()
    }
    
    @objc func getTitle() -> String {
        if let mobber = mobberManager.getCurrentMobber() {
            return "\(mobber.name) \(timer.time())"
        }
        return "MobSquad"
    }
    
    func timeoutDialog() -> NSApplication.ModalResponse {
        let alert = NSAlert()
        alert.messageText = "Time's Up!"
        if let mobber = mobberManager.getNextMobber() {
            alert.informativeText = "\(mobber.name), sit on the keyboard"
        }
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Start")
        alert.addButton(withTitle: "Skip")
        alert.addButton(withTitle: "Preferences")
        return alert.runModal()
    }
    
    /* Update the status bar item menu */
    func updateMenu() {
        // Play or pause
        playPauseItem.title = timer.inProgress ? "Pause" : "Play"
        
        // Next mobber
        if let nextMobber = mobberManager.getNextMobber() {
            nextItem.title = "Next: \(nextMobber.name)"
        }
        
        // Disabling buttons
        let enabled = !mobberManager.mobbers.isEmpty
        playPauseItem.isEnabled = enabled
        nextItem.isEnabled = enabled
        resetItem.isEnabled = enabled
    }

    /**
     * Construct the menu for status bar button.
     */
    func constructMenu() {
        menu.addItem(playPauseItem)
        menu.addItem(resetItem)
        menu.addItem(nextItem)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(settingsItem)
        menu.addItem(quitItem)
        
        menu.autoenablesItems = false
        updateMenu()
        statusItem.menu = menu
    }


    /* Play the timer if not in progress. Pause it otherwise */
    @objc func toggleTimer(_ sender: Any?) {
        if mobberManager.mobbers.isEmpty { return }
        timer.inProgress ? timer.pause() : timer.play()
        updateMenu()
    }
    
    @objc func resetTimer(_ sender: Any?) {
        timer.stop()
    }
    
    @objc func openSettings(_ sender: Any?) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: "SettingsWindow") as! NSWindowController
        controller.showWindow(self)
        if let window = controller.window {
            print("here")
            window.makeKeyAndOrderFront(storyboard)
        }
    }
    
    @objc func nextMobber(_ sender: Any) {
        mobberManager.next()
        timer.stop()
    }

}

