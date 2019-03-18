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
    
    // UI
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    
    // Models
    // Need to grab from database
    var mobberManager: MobberManager
    var timer: MobTimer
    
    override init() {
        mobbers = userDefaults.stringArray(forKey: "mobbers") ?? ["Gino"]
        minutes = userDefaults.integer(forKey: "minutes")
        shuffle = userDefaults.bool(forKey: "shuffle")
        
        mobberManager = MobberManager(mobbers: self.mobbers)
        timer = MobTimer(minutes: self.minutes)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidChangeTime(_:)), name: .didChangeTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidChangeMobber(_:)), name: .didChangeMobber, object: nil)
        

        

        updateStatusItemTitle(title: getTitle())
        constructMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    /* Update the status item's title with given title */
    func updateStatusItemTitle(title: String) {
        if let button = statusItem.button {
            button.title = title
        }
    }

    @objc func onDidChangeTime(_ notification: Notification) {
        if timer.seconds == 0 {
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

        updateStatusItemTitle(title: getTitle())
    }
    
    @objc func onDidChangeMobber(_ notification: Notification) {
        updateStatusItemTitle(title: getTitle())
    }
    
    @objc func getTitle() -> String {
        let mobber = mobberManager.getCurrentMobber()
        if let unwrappedMobber = mobber {
            return "\(unwrappedMobber.name) \(timer.time())"
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

    /**
     * Construct the menu for status bar button.
     */
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Play / Pause", action: #selector(AppDelegate.toggleTimer(_:)), keyEquivalent: "p"))
        menu.addItem(NSMenuItem(title: "Reset", action: #selector(AppDelegate.resetTimer(_:)), keyEquivalent: "s"))
        menu.addItem(NSMenuItem(title: "Next", action: #selector(AppDelegate.nextMobber(_:)), keyEquivalent: "n"))
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }


    /* Play the timer if not in progress. Pause it otherwise */
    @objc func toggleTimer(_ sender: Any?) {
        timer.inProgress ? timer.pause() : timer.play()
    }
    
    @objc func resetTimer(_ sender: Any?) {
        timer.stop()
    }
    
    @objc func printQuote(_ sender: Any?) {
        print("Preferences")
    }
    
    @objc func nextMobber(_ sender: Any) {
        mobberManager.next()
        timer.stop()
    }

}

