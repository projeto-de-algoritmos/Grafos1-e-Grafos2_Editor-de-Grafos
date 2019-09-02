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
    var currentlyDrawnLine: EdgeNode<GraphNode>?
    
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
            currentlyDrawnLine = EdgeNode(source: Vertex<GraphNode>(data: touchedGraphNode), initialPosition: touchedGraphNode.position)
            isDrawingLine = true
            self.addChild(currentlyDrawnLine!)
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if isDrawingLine {
            currentlyDrawnLine!.moveEndOfLine(to: event.location(in: self))
        }
    }
    
    var hoveredEdges: Queue<EdgeNode<GraphNode>> = Queue<EdgeNode<GraphNode>>()
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        
        let location = event.location(in: self)
        let touchedNodes = nodes(at: location)
        
        var touchedEdgeNode: EdgeNode<GraphNode>? = nil
        for touchedNode in touchedNodes {
            if touchedNode is EdgeNode<GraphNode> {
                touchedEdgeNode = (touchedNode as! EdgeNode<GraphNode>)
                touchedEdgeNode!.displayDeleteButton()
                if hoveredEdges.peek() != touchedEdgeNode {
                    hoveredEdges.enqueue(touchedEdgeNode!)
                }
                
                
                if hoveredEdges.count > 1 {
                    hoveredEdges.dequeue()?.hideDeleteButton()
                }
                
                break
            }
        }
        
        if touchedEdgeNode == nil && hoveredEdges.count == 1 {
            hoveredEdges.dequeue()!.hideDeleteButton()
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        let location = event.location(in: self)
        let touchedNodes = nodes(at: location)
        
        var hasDeletedAnEdge = false
        
        var touchedGraphNode: GraphNode? = nil
        for touchedNode in touchedNodes {
            if touchedNode is GraphNode {
                touchedGraphNode = (touchedNode as! GraphNode)
            } else if touchedNode.name == "deleteButton" {
                let source = (touchedNode.parent as! EdgeNode<GraphNode>).source
                if let destination = (touchedNode.parent as! EdgeNode<GraphNode>).destination {
                    adjacencyList.deleteEdge(between: source, and: destination)
                    let edgeNode = touchedNode.parent
                    edgeNode?.removeAllChildren()
                    edgeNode?.removeFromParent()
                    hasDeletedAnEdge = true
                    
                    adjacencyListString = adjacencyList.description as! String
                    areComponentsBipartite = isBipartite(graph: adjacencyList)
                }
            }
        }
        if isDrawingLine {
            if touchedGraphNode != nil {
                currentlyDrawnLine!.moveEndOfLine(to: touchedGraphNode!.position)
                currentlyDrawnLine!.destination = Vertex<GraphNode>(data: touchedGraphNode!)
            } else {
                currentlyDrawnLine!.removeFromParent()
            }
            
            currentlyDrawnLine = nil
            isDrawingLine = false

            if let _initialNode = initialNode,
                let _endNode = touchedGraphNode,
                _initialNode != touchedGraphNode {

                let initialVertex = Vertex<GraphNode>(data: _initialNode)
                let endVertex = Vertex<GraphNode>(data: _endNode)

                adjacencyList.add(.undirected, from: initialVertex, to: endVertex, weight: 0)

                adjacencyListString = adjacencyList.description as! String
                
                areComponentsBipartite = isBipartite(graph: adjacencyList)
            }

            initialNode = nil

        } else if !hasDeletedAnEdge {
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
                        (neighborNode.data as! GraphNode).fillColor = vertexColor[neighborNode] == 2 ? NSColor(calibratedRed: 39/255, green: 60/255, blue: 117/255, alpha: 1) : NSColor(calibratedRed: 194/255, green: 54/255, blue: 22/255, alpha: 1)
                        (neighborNode.data as! GraphNode).graphNodeIndex.fontColor = vertexColor[neighborNode] == 2 ? .white : .black
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


