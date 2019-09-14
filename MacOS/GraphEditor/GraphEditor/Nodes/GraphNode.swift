//
//  GraphNode.swift
//  GraphEditor
//
//  Created by Matheus Felizola Freires on 31/08/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import SpriteKit

class GraphNode: SKShapeNode {

    let graphNodeIndex: SKLabelNode!

    init(index: Int) {
        graphNodeIndex = SKLabelNode(text: String(index))
        graphNodeIndex.fontColor = .black
        graphNodeIndex.name = "graphNodeIndex"
        graphNodeIndex.verticalAlignmentMode = .center

        super.init()

        let radius = 30
        self.path = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius*2, height: radius*2), transform: nil)
        self.fillColor = .white
        self.strokeColor = .black
        self.lineWidth = 3
        
        self.addChild(graphNodeIndex)
    }
    
    func colorAsStartNode() {
        self.fillColor = NSColor(calibratedRed: 194/255, green: 54/255, blue: 22/255, alpha: 1)
        self.graphNodeIndex.fontColor = .black
    }
    
    func colorAsEndNode() {
        self.fillColor = NSColor(calibratedRed: 39/255, green: 60/255, blue: 117/255, alpha: 1)
        self.graphNodeIndex.fontColor = .white
    }
    
    func colorAsNormalNode() {
        self.fillColor = .white
        self.graphNodeIndex.fontColor = .black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var description: String {
        return graphNodeIndex.text ?? "-1"
    }
}

