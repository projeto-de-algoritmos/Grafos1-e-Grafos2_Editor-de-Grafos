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

//        let dungeon = AdjacencyList<String>()
//
//        let entranceRoom = dungeon.createVertex(data: "Entrance")
//        let spiderRoom = dungeon.createVertex(data: "Spider")
//        let goblinRoom = dungeon.createVertex(data: "Goblin")
//        let ratRoom = dungeon.createVertex(data: "Rat")
//        let treasureRoom = dungeon.createVertex(data: "Treasure")
//
//        dungeon.add(.undirected, from: entranceRoom, to: spiderRoom, weight: 11)
//        dungeon.add(.undirected, from: spiderRoom, to: goblinRoom, weight: 11)
//        dungeon.add(.undirected, from: goblinRoom, to: treasureRoom, weight: 11)
//        dungeon.add(.undirected, from: entranceRoom, to: ratRoom, weight: 31)
//        dungeon.add(.undirected, from: ratRoom, to: treasureRoom, weight: 12)
//
//        print(dungeon.description)
//
//
//        if let edges = dungeon.dijkstra(from: entranceRoom, to: treasureRoom) {
//            for edge in edges {
//                print("\(edge.source) -> \(edge.destination)")
//            }
//        }

    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        skView.window?.acceptsMouseMovedEvents = true
        skView.window?.initialFirstResponder = skView
        skView.window?.makeFirstResponder(skView.scene)
        
    }
}

