//
//  ViewController.swift
//  GraphEditor
//
//  Created by Matheus Felizola Freires on 30/08/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)

            view.ignoresSiblingOrder = true
        }
    }
}

