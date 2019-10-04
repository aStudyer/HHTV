//
//  ViewController.swift
//  SocketServer
//
//  Created by aStudyer on 2019/10/2.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var lbTip: NSTextField!
    private lazy var serverManager: ServerManager = ServerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func startServer(_ sender: NSButton) {
        serverManager.startRunning()
        lbTip.stringValue = "服务器已开启"
    }
    @IBAction func stopServer(_ sender: NSButton) {
        serverManager.stopRunning()
        lbTip.stringValue = "服务器未开启"
    }
}

