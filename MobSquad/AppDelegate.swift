//
//  AppDelegate.swift
//  MobSquad
//
//  Created by Gino V. Jacob on 3/13/19.
//  Copyright © 2019 Gino V. Jacob. All rights reserved.
//

import Cocoa

extension Notification.Name {
    static let didChangeTime = Notification.Name("didChangeTime")
    static let didChangeMobber = Notification.Name("didChangeMobber")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let mobberManager = MobberManager(mobbers: ["Gino", "Alan", "Nate", "Margarita"])
    let timer = MobTimer(minutes: 12)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidChangeTime(_:)), name: .didChangeTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidChangeMobber(_:)), name: .didChangeMobber, object: nil)
        
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.title = getTitle()
        }
        
        constructMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func onDidChangeTime(_ notification: Notification) {
        if timer.seconds == 0 {
            timer.stop()
            let buttonPressed = timeoutDialog().rawValue
            switch buttonPressed {
            case 1000:
                mobberManager.nextMobber()
                timer.play()
            case 1001:
                mobberManager.nextMobber()
                mobberManager.nextMobber()
            default:
                mobberManager.nextMobber()
                timer.play()
            }
        }
        
        if let button = statusItem.button {
            button.title = getTitle()
        }
    }
    
    @objc func onDidChangeMobber(_ notification: Notification) {
        if let button = statusItem.button {
            button.title = getTitle()
        }
    }
    
    @objc func getTitle() -> String {
        return "\(mobberManager.currentMobber) - \(timer.time)"
    }
    
    func timeoutDialog() -> NSApplication.ModalResponse {
        let alert = NSAlert()
        alert.messageText = "Time's Up!"
        alert.informativeText = "\(mobberManager.getNextMobberName()), sit on the keyboard"
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
        mobberManager.nextMobber()
        timer.stop()
    }

}

