//
//  GameScene.swift
//  GraphEditor
//
//  Created by Matheus Felizola Freires on 30/08/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var nodeIndex = 0
    var isDrawingLine = false
    var currentlyDrawnLine: SKShapeNode?
    var currentInitialPositionOfLine: CGPoint?
    var adjacencyList = AdjacencyList<GraphNode>()

    fileprivate var initialNode: GraphNode?
    fileprivate var endNode: GraphNode?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
    }
    
    func touchDown(atPoint pos: CGPoint) {
        
    }
    
    func touchMoved(toPoint pos: CGPoint) {
        
    }
    
    func touchUp(atPoint pos: CGPoint) {
        let graphNode = GraphNode(index: nodeIndex)
        nodeIndex += 1
        self.addChild(graphNode)
        graphNode.position = CGPoint(x: pos.x, y: pos.y)

        _ = adjacencyList.createVertex(data: graphNode)
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let touchedNodes = nodes(at: location)
        
        var touchedGraphNode: GraphNode? = nil
        for touchedNode in touchedNodes {
            if touchedNode is GraphNode {
                touchedGraphNode = (touchedNode as! GraphNode)
                initialNode = touchedGraphNode
                break
            }
        }
        if let touchedGraphNode = touchedGraphNode {
            let linePath = CGMutablePath()
            linePath.move(to: touchedGraphNode.position)
            linePath.addLine(to: touchedGraphNode.position)
            currentlyDrawnLine = SKShapeNode(path: linePath)
            currentlyDrawnLine!.strokeColor = .black
            currentlyDrawnLine?.lineWidth = 3
            currentInitialPositionOfLine = touchedGraphNode.position
            isDrawingLine = true
            currentlyDrawnLine!.zPosition = -1
            self.addChild(currentlyDrawnLine!)
        } else {
            self.touchDown(atPoint: event.location(in: self))
        }
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
        if isDrawingLine {
            let linePath = CGMutablePath()
            linePath.move(to: currentInitialPositionOfLine!)
            linePath.addLine(to: event.location(in: self))
            currentlyDrawnLine!.path = linePath
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        let location = event.location(in: self)
        let touchedNodes = nodes(at: location)
        
        var touchedGraphNode: GraphNode? = nil
        for touchedNode in touchedNodes {
            if touchedNode is GraphNode {
                touchedGraphNode = (touchedNode as! GraphNode)
                endNode = touchedGraphNode
                break
            }
        }
        if isDrawingLine {
            if touchedGraphNode != nil {
                let linePath = CGMutablePath()
                linePath.move(to: currentInitialPositionOfLine!)
                linePath.addLine(to: touchedGraphNode!.position)
                currentlyDrawnLine!.path = linePath
            } else {
                currentlyDrawnLine!.removeFromParent()
            }
            
            currentInitialPositionOfLine = nil
            currentlyDrawnLine = nil
            isDrawingLine = false

            if let _initialNode = initialNode,
                let _endNode = endNode,
                _initialNode != endNode {

                guard let initialVertex = adjacencyList.adjacencyDict.keys.first(where: { $0.data.graphNodeIndex.text == _initialNode.graphNodeIndex.text }) else { return }
                guard let endVertex = adjacencyList.adjacencyDict.keys.first(where: { $0.data.graphNodeIndex.text == _endNode.graphNodeIndex.text }) else { return }

                adjacencyList.add(.undirected, from: initialVertex, to: endVertex, weight: 0)

                print(adjacencyList.description)
            }

            initialNode = nil
            endNode = nil

        } else {
            self.touchUp(atPoint: event.location(in: self))
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            break
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
