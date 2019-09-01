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
    var adjacencyListLabel: SKLabelNode!
    var numberOfCyclesLabel: SKLabelNode!
    var numberOfCycles = 0 {
        didSet {
            numberOfCyclesLabel.text = "Number of Cycles: \(numberOfCycles)"

        }
    }
    var adjacencyListString = "" {
        didSet {
            adjacencyListLabel.text = adjacencyListString
            adjacencyListLabel.position = CGPoint(x: size.width * 0.02, y: size.height * 0.95)
        }
    }

    fileprivate var initialNode: GraphNode?
    fileprivate var endNode: GraphNode?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        setupAdjacencyListLabel()
        setupNumberOfCyclesLabel()
    }

    func setupAdjacencyListLabel() {
        adjacencyListLabel = SKLabelNode(text: "")
        adjacencyListLabel.numberOfLines = 20
        adjacencyListLabel.position = CGPoint(x: size.width * 0.02, y: size.height * 0.95)
        adjacencyListLabel.fontColor = .black
        adjacencyListLabel.horizontalAlignmentMode = .left
        adjacencyListLabel.verticalAlignmentMode = .top
        addChild(adjacencyListLabel)
    }

    func setupNumberOfCyclesLabel() {
        numberOfCyclesLabel = SKLabelNode(text: "Number Of Cycles: ")
        numberOfCyclesLabel.position = CGPoint(x: size.width * 0.75, y: size.height * 0.9)
        numberOfCyclesLabel.fontColor = .black
        addChild(numberOfCyclesLabel)
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

                adjacencyListString = adjacencyList.description as! String
                _ = depthFirstSearch(from: initialVertex, to: endVertex, graph: adjacencyList)
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

    // MARK: - DFS

    func depthFirstSearch<T: Hashable>(from start: Vertex<T>, to end: Vertex<T>, graph: AdjacencyList<T>) -> Stack<Vertex<T>> {

        var visited = Set<Vertex<T>>()
        var stack = Stack<Vertex<T>>()

        numberOfCycles = 0

        stack.push(start)
        visited.insert(start)

        outer: while let vertex = stack.peek()/*, vertex != end*/ {

            guard let neighbors = graph.edges(from: vertex),
                neighbors.count > 0 else {
                    _ = stack.pop()
                    continue
            }

            for edge in neighbors {
                if visited.contains(edge.destination),
                    stack.contains(edge.destination) {
                    if let a = stack.lastMinusOne() {
                        if a != edge.destination {
                            print()
                            print("Começa aqui")
                            print()
                            print(a)
                            print(edge.destination)
                            print(stack.description)
                            numberOfCycles += 1
                            print()
                            print("Começa aqui")
                            print()
                        }
                    }
                }

                if !visited.contains(edge.destination) {
                    visited.insert(edge.destination)
                    stack.push(edge.destination)
                    print(stack.description)
                    continue outer
                }
            }

            print("backtrack from \(vertex)")
            _ = stack.pop()
        }

        return stack
    }
}


