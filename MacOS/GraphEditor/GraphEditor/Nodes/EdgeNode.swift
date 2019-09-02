//
//  EdgeNode.swift
//  GraphEditor
//
//  Created by Matheus Felizola Freires on 02/09/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import SpriteKit

class EdgeNode<T: Hashable>: SKShapeNode {
    let source: Vertex<T>
    var destination: Vertex<T>? = nil
    
    let initialPosition: CGPoint
    let deleteButton: SKShapeNode = {
        let circle = SKShapeNode(circleOfRadius: 10)
        let xLabel = SKLabelNode(text: "X")
        circle.fillColor = .white
        circle.strokeColor = .black
        circle.lineWidth = 2
        xLabel.fontColor = .red
        xLabel.horizontalAlignmentMode = .center
        xLabel.verticalAlignmentMode = .center
        xLabel.fontSize = 14
        xLabel.fontName = xLabel.fontName! + "-Bold"
        circle.name = "deleteButton"
        
        circle.addChild(xLabel)
        
        return circle
    }()
    
    init(source: Vertex<T>, initialPosition: CGPoint) {
        self.source = source
        self.initialPosition = initialPosition
        super.init()
        hideDeleteButton()
        
        addChild(deleteButton)
        
        moveEndOfLine(to: initialPosition)
        self.strokeColor = .black
        self.lineWidth = 3
        self.zPosition = -1
    }
    
    func moveEndOfLine(to pos: CGPoint) {
        let linePath = CGMutablePath()
        linePath.move(to: initialPosition)
        linePath.addLine(to: pos)
        self.path = linePath
        
        deleteButton.position = CGPoint(x: initialPosition.x + (pos.x-initialPosition.x)/2, y: initialPosition.y + (pos.y-initialPosition.y)/2)
    }
    
    func displayDeleteButton() {
        deleteButton.isHidden = false
    }
    
    func hideDeleteButton() {
        deleteButton.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
