//
//  ViewController.swift
//  MobSquad
//
//  Created by Gino V. Jacob on 3/13/19.
//  Copyright © 2019 Gino V. Jacob. All rights reserved.
//

import Cocoa

var name = ""

class ViewController: NSViewController {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    var mobbers: Array<(String, Bool)> = []
    
    override func viewWillAppear() {
        mobbers = appDelegate.mobberManager.mobbers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

