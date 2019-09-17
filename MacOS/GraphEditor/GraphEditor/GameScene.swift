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
    
    var adjacencyListString = "" {
        didSet {
            adjacencyListLabel.text = adjacencyListString
        }
    }

    fileprivate var initialNode: GraphNode?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        let cameraNode = SKCameraNode()
        
        cameraNode.position = .zero//CGPoint(x: scene!.size.width / 2, y: scene!.size.height / 2)
        
        addChild(cameraNode)
        camera = cameraNode
        setupAdjacencyListLabel()
    }

    func setupAdjacencyListLabel() {
        adjacencyListLabel = SKLabelNode(text: "")
        adjacencyListLabel.numberOfLines = 20
        adjacencyListLabel.position = CGPoint(x: -size.width/2 + size.width * 0.02, y: -size.height/2 + size.height * 0.95)
        adjacencyListLabel.zPosition = 100
        adjacencyListLabel.fontColor = .black
        adjacencyListLabel.horizontalAlignmentMode = .left
        adjacencyListLabel.verticalAlignmentMode = .top
        adjacencyListLabel.fontSize = 24
        adjacencyListLabel.fontName = adjacencyListLabel.fontName! + "-Bold"
        self.camera!.addChild(adjacencyListLabel)
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
        //adjacencyListLabel.position = event.location(in: self.camera!)
        print(adjacencyListLabel.position)
        print(size)
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
    
    func dialogOKCancel(question: String, text: String) -> Double? {
        let alert: NSAlert = NSAlert()
        alert.messageText = question
        alert.accessoryView = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 20))
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "Continue")
        let res = alert.runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
            return Double((alert.accessoryView as! NSTextField).stringValue)
        }
        return nil
    }
    
    override func scrollWheel(with event: NSEvent) {
        self.camera!.position = CGPoint(x: self.camera!.position.x - event.scrollingDeltaX/3, y: self.camera!.position.y + event.scrollingDeltaY/3)
    }
    
    var paintedEdgeNodes: [EdgeNode<GraphNode>] = []
    
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

            if let _initialNode = initialNode,
                let _endNode = touchedGraphNode,
                _initialNode != touchedGraphNode {

                let initialVertex = Vertex<GraphNode>(data: _initialNode)
                let endVertex = Vertex<GraphNode>(data: _endNode)

                
                let answer = dialogOKCancel(question: "What's the weight of this edge?", text: "") ?? 0
                currentlyDrawnLine!.weight = answer
                
                adjacencyList.add(.undirected, from: initialVertex, to: endVertex, weight: answer)
                
                adjacencyListString = adjacencyList.description as! String
                
                for paintedEdgeNode in paintedEdgeNodes {
                    paintedEdgeNode.unpaint()
                }
                paintedEdgeNodes.removeAll(keepingCapacity: true)
                
                let prim = Prim<GraphNode>()
                for edge in prim.produceMinimumSpanningTree(graph: adjacencyList).mst.edges() {
                    for node in nodes(at: edge.source.data.position) {
                        if let edgeNode = node as? EdgeNode<GraphNode> {
                            if edgeNode.source == edge.source && edgeNode.destination == edge.destination
                                || edgeNode.source == edge.destination && edgeNode.destination == edge.source{
                                edgeNode.paintAsPath()
                                paintedEdgeNodes.append(edgeNode)
                            }
                        }
                    }
                }
            }
            
            currentlyDrawnLine = nil
            isDrawingLine = false

            initialNode = nil
        } else if !hasDeletedAnEdge && touchedGraphNode == nil {
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
            nodeIndex = 1
            break
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
}
