import Foundation
import SceneKit

class TileManager {
    // Scene
    private let scene : SCNScene
    
    // Tiles
    private var tileNodes : [TileNode] = []
    private var tileCoordinates = TileCoordinates()
    
    // Spike Nodes
    private var spikeNodes : [TileNode] = []
    
    init(scene : SCNScene) {
        self.scene = scene
        setUpInitialTileNodes()
    }
}

// MARK: - Add Tile Node
extension TileManager {
    func addNewTile(_ tileId : UUID?) {
        guard let firstTileNode = tileNodes.first else { return }
        removeTileNode(firstTileNode)
        addTileNode()
        removeDeadZoneNode(tileId)
    }
    
    private func addTileNode(_ isInitialTile : Bool = false) {
        guard let tilePosition = TilePosition.allCases.randomElement() else { return }
        let tileNode = TileNode(tilePosition: tilePosition,
                                isFirstTile: isInitialTile,
                                isSpikeNode: false)
        tileNode.contactHandled = isInitialTile // This stops 1 point being added at start of game
        self.tileNodes.append(tileNode)
        setTilePosition(tileNode, isInitialTile)
        Utils.addNodeToScene(scene, tileNode)
    }
    
    private func setTilePosition(_ tileNode : TileNode, _ isInitialTile : Bool) {
        let position = SCNVector3(tileCoordinates.xPosition,
                                  tileCoordinates.yPosition,
                                  tileCoordinates.zPosition)
        tileNode.updatePosition(position: position)
        
        // Add the spike node
        addSpikeNode(position: position, isInitialTile: isInitialTile, tilePosition: tileNode.tilePosition)
        
        // Set next Y position
        tileCoordinates.yPosition -= 2 // Next block should always be place below current block
        // Set next X position
        tileCoordinates.xPosition = tileNode.tilePosition == .right ?
        (tileCoordinates.xPosition + 4) : tileCoordinates.xPosition
        // Set next Z position
        tileCoordinates.zPosition = tileNode.tilePosition == .right ?
        tileCoordinates.zPosition : (tileCoordinates.zPosition + 4)
    }
    
    private func addSpikeNode(position : SCNVector3,
                              isInitialTile : Bool,
                              tilePosition : TilePosition) {
        guard let spikeNodePosition = TilePosition.allCases.randomElement() else { return }
        let spikeNode = TileNode(tilePosition: spikeNodePosition,
                                 isFirstTile: isInitialTile,
                                 isSpikeNode: true)
        self.spikeNodes.append(spikeNode)
        self.setSpikeNodePosition(position: position, tilePosition: tilePosition, spikeNode: spikeNode)
        Utils.addNodeToScene(scene, spikeNode)
    }
    
    private func setSpikeNodePosition(position : SCNVector3,
                                      tilePosition : TilePosition,
                                      spikeNode : TileNode) {
        let y = position.y
        let x = (tilePosition == .left) ? (position.x + 4) : (position.x - 4)
        let z = (tilePosition == .left) ? (position.z - 4) : (position.z + 4)
        let spikePosition = SCNVector3(x, y, z)
        spikeNode.updatePosition(position: spikePosition)
        
    }
}

// MARK: - Remove nodes
extension TileManager {
    private func removeTileNode(_ tileNode : TileNode) {
        if self.tileNodes.count > Constants.maxNumberOfTiles {
            tileNode.removeFromParentNode()
            tileNodes.removeFirst()
        }
    }
    
    private func removeDeadZoneNode(_ tileId : UUID?) {
        let contactedTile = tileNodes.first(where: { $0.id == tileId })
        guard let contactedTile else { return }
        contactedTile.removeDeadZone()
    }
}

// MARK: - Set up initial tile nodes
private extension TileManager {
    func setUpInitialTileNodes() {
        for i in Constants.rangeOfInitialNodes {
            addTileNode((i == 0))
        }
    }
}

// MARK: - Restart Game
extension TileManager {
    func reset() {
        // This is to replay the exact same layout of tiles
        // Although, if you keep replaying, the tile nodes will keep dissapearing from under the player
        // As the number of tiles on the list has reached the Constants.maxNumberOfTiles
        
//        self.tileNodes = self.tileNodes.map({ tileNode in
//            var newTileNode = tileNode
//            newTileNode.contactHandled = false
//            return newTileNode
//        })      
        for tileNode in tileNodes {
            tileNode.removeFromParentNode()
        }
        self.tileNodes.removeAll()
        self.tileCoordinates = TileCoordinates()
        self.setUpInitialTileNodes()
    }
}

enum TilePosition : CaseIterable {
    case left, right
}
