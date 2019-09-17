//
//  EdgeNode.swift
//  GraphEditor
//
//  Created by Matheus Felizola Freires on 02/09/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import SpriteKit

class EdgeNode<T: Hashable>: SKShapeNode {
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let source: Vertex<T>
    var destination: Vertex<T>? = nil
    var weight: Double = 0 {
        didSet {
            weightLabel.text = formatter.string(from: NSNumber(value: weight))
        }
    }
    
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

    var weightLabel: SKLabelNode!

    func setupWeightLabel() {
        weightLabel = SKLabelNode(text: formatter.string(from: NSNumber(value: weight)))
        weightLabel.name = "WeightLabel"
        weightLabel.fontColor = .black
        weightLabel.horizontalAlignmentMode = .center
        weightLabel.verticalAlignmentMode = .center
        weightLabel.fontSize = 22
        weightLabel.fontName = weightLabel.fontName! + "-Bold"
        addChild(weightLabel)
    }
    
    init(source: Vertex<T>, initialPosition: CGPoint) {
        self.source = source
        self.initialPosition = initialPosition
        super.init()
        setupWeightLabel()
        hideDeleteButton()
        
        addChild(deleteButton)


        moveEndOfLine(to: initialPosition)
        self.strokeColor = .black
        self.lineWidth = 3
        self.zPosition = -1
    }
    
    func paintAsPath() {
        self.strokeColor = .orange
    }
    
    func unpaint() {
        self.strokeColor = .black
    }
    
    func moveEndOfLine(to pos: CGPoint) {
        let linePath = CGMutablePath()
        linePath.move(to: initialPosition)
        linePath.addLine(to: pos)
        self.path = linePath
        
        deleteButton.position = CGPoint(x: initialPosition.x + (pos.x-initialPosition.x)/2, y: initialPosition.y + (pos.y-initialPosition.y)/2)
        weightLabel.zRotation = atan2(initialPosition.y-pos.y, initialPosition.x-pos.x)
        if weightLabel.zRotation > CGFloat.pi/2 {
            weightLabel.zRotation -= CGFloat.pi
        } else if weightLabel.zRotation < -CGFloat.pi/2 {
            weightLabel.zRotation += CGFloat.pi
        }
        weightLabel.position = CGPoint(x: initialPosition.x + (pos.x-initialPosition.x)/2 + 10 * cos(weightLabel.zRotation + CGFloat.pi/2), y: initialPosition.y + (pos.y-initialPosition.y)/2 + 10 * sin(weightLabel.zRotation + CGFloat.pi/2))
        
    }
    
    func displayDeleteButton() {
        deleteButton.isHidden = false
        weightLabel.isHidden = true
    }
    
    func hideDeleteButton() {
        deleteButton.isHidden = true
        weightLabel.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
