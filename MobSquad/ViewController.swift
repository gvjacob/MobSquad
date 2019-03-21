//
//  ViewController.swift
//  MobSquad
//
//  Created by Gino V. Jacob on 3/13/19.
//  Copyright © 2019 Gino V. Jacob. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    // Models
    let app = NSApplication.shared.delegate as! AppDelegate
    var mobberManager: MobberManager
    var timer: MobTimer
    
    // UI Data
    var selectedRows: IndexSet = []
    
    override func keyDown(with event: NSEvent) {
        print(event.keyCode)
        if event.keyCode == 51 {
            self.selectedRows.reversed().forEach {
                let mobberName = self.mobberManager.mobbers[$0].name
                mobberManager.removeMobber(name: mobberName)
                reloadMobberList()
            }
            self.selectedRows = []
        } else if event.keyCode == 36 {
            addMobberIfInput()
        }
    }
    
    // UI Connections
    @IBOutlet weak var mobberTable: NSTableView!
    @IBOutlet weak var minutesField: NSTextField!
    @IBOutlet weak var addMobberField: NSTextField!
    
    @IBAction func shuffleButton(_ sender: NSButton) {
        timer.stop()
        mobberManager.shuffle()
        reloadMobberList()
    }
    
    @IBAction func addMobberFieldAction(_ sender: Any) {
        addMobberIfInput()
    }
    
    @IBAction func addMobberButton(_ sender: NSButton) {
        addMobberIfInput()
    }
    
    func addMobberIfInput() {
        let mobberName = addMobberField.stringValue
        if !mobberManager.mobbers.contains(where: { $0.name == mobberName }) && mobberName != "" {
            mobberManager.addMobber(name: mobberName)
            addMobberField.stringValue = ""
            reloadMobberList()
        }
    }
    
    @IBAction func textShouldEndEditing(_ sender: NSTextField) {
        let newMinutes = Int(sender.stringValue)
        if let minutes = newMinutes {
            if minutes > 0 && minutes <= 60 {
                timer.minutes = minutes
                timer.stop()
            }
        }
        
        minutesField.stringValue = String(timer.minutes)
    }
    
    override init(nibName: NSNib.Name?, bundle: Bundle?) {
        mobberManager = app.mobberManager
        timer = app.timer
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init(coder: NSCoder) {
        mobberManager = app.mobberManager
        timer = app.timer
        super.init(coder: coder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobberTable.delegate = self
        mobberTable.dataSource = self
        
        minutesField.stringValue = String(timer.minutes)

    }
    
    func reloadMobberList() {
        mobberTable.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}



extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return mobberManager.mobbers.count
    }
}

extension ViewController: NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let MobberName = "MobberName"
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableView = notification.object as! NSTableView
        self.selectedRows = tableView.selectedRowIndexes
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if mobberManager.mobbers.isEmpty {
            return nil
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.MobberName), owner: nil) as? NSTableCellView {
            let mobbers = mobberManager.mobbers
            let mobberName = mobbers[row].name
            cell.textField?.stringValue = mobberName
            return cell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("MobberName"), owner: nil) as? NSTableCellView {
            let mobbers = mobberManager.mobbers
            let mobberName = mobbers[row].name
            cell.textField?.stringValue = mobberName
            return cell
        }

        return nil
    }
}
