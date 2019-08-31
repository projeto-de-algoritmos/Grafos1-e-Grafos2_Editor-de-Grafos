//
//  GraphNode.swift
//  GraphEditor
//
//  Created by Matheus Felizola Freires on 31/08/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import SpriteKit

class GraphNode: SKShapeNode {
    /*override var isUserInteractionEnabled: Bool {
        get {
            return true
        } set {}
    }*/
    
    init(index: Int) {
        super.init()
        let radius = 30
        self.path = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius*2, height: radius*2), transform: nil)
        self.fillColor = .white
        self.strokeColor = .black
        self.lineWidth = 3
        
        let graphNodeIndex = SKLabelNode(text: String(index))
        graphNodeIndex.fontColor = .black
        self.addChild(graphNodeIndex)
        graphNodeIndex.verticalAlignmentMode = .center
    }
    
    /*override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
