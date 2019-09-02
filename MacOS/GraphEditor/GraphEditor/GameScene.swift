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
    var nodeIndex = 1
    var isDrawingLine = false
    var currentlyDrawnLine: SKShapeNode?
    var currentInitialPositionOfLine: CGPoint?
    var adjacencyList = AdjacencyList<GraphNode>()
    var adjacencyListLabel: SKLabelNode!
    var bipartitenessLabel: SKLabelNode!
    
    var areComponentsBipartite = true {
        didSet {
            bipartitenessLabel.text = "Are the components bipartite? \(areComponentsBipartite)"
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
        setupBipartitenessLabel()
    }

    func setupAdjacencyListLabel() {
        adjacencyListLabel = SKLabelNode(text: "")
        adjacencyListLabel.numberOfLines = 20
        adjacencyListLabel.position = CGPoint(x: size.width * 0.02, y: size.height * 0.95)
        adjacencyListLabel.fontColor = .black
        adjacencyListLabel.horizontalAlignmentMode = .left
        adjacencyListLabel.verticalAlignmentMode = .top
        adjacencyListLabel.fontSize = 24
        adjacencyListLabel.fontName = adjacencyListLabel.fontName! + "-Bold"
        addChild(adjacencyListLabel)
    }

    func setupBipartitenessLabel() {
        bipartitenessLabel = SKLabelNode(text: "Are the components bipartite?")
        bipartitenessLabel.position = CGPoint(x: size.width * 0.95, y: size.height * 0.9)
        bipartitenessLabel.fontColor = .black
        bipartitenessLabel.horizontalAlignmentMode = .right
        addChild(bipartitenessLabel)
    }
    
    func touchUp(atPoint pos: CGPoint) {
        let graphNode = GraphNode(index: nodeIndex)
        nodeIndex += 1
        self.addChild(graphNode)
        graphNode.position = CGPoint(x: pos.x, y: pos.y)

        _ = adjacencyList.createVertex(data: graphNode)
        adjacencyListString = adjacencyList.description as! String
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
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
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
                
                areComponentsBipartite = isBipartite(graph: adjacencyList)
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
            adjacencyList.reset()
            self.removeAllChildren()
            adjacencyListString = adjacencyList.description as! String
            setupAdjacencyListLabel()
            setupBipartitenessLabel()
            nodeIndex = 1
            break
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    func isBipartite<T: Hashable>(graph: AdjacencyList<T>) -> Bool {
        var verticesToVisit = Set<Vertex<T>>()
        var vertexColor: Dictionary<Vertex<T>, Int> = Dictionary<Vertex<T>, Int>()
        for key in graph.adjacencyDict.keys {
            vertexColor[key] = -1
            verticesToVisit.insert(key)
        }
        
        //Visit each component
        repeat {
            var queue = Queue<Vertex<T>>()
            queue.enqueue(verticesToVisit.first!)
            
            print("---------------------------")
            
            print(verticesToVisit.first!.data)
            while let current = queue.dequeue() {
                verticesToVisit.remove(current)
                for edge in graph.adjacencyDict[current] ?? [] {
                    let neighborNode = edge.destination
                    
                    if vertexColor[neighborNode] == -1 {
                        vertexColor[neighborNode] = 1-vertexColor[current]!
                        queue.enqueue(neighborNode)
                        verticesToVisit.remove(neighborNode)
                        print(neighborNode.data)
                    } else if vertexColor[current] == vertexColor[neighborNode] {
                        return false
                    }
                }
            }
        } while verticesToVisit.count > 0
        
        return true
    }
}


