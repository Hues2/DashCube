import Foundation
import SceneKit

class TileManager {
    // Scene
    private let scene : SCNScene
    private let playerCube : PlayerCubeNode
    
    // Tiles
    private var tileNodes : [TileNode] = []
    private var tileCoordinates = TileCoordinates()
    
    // Spike Nodes
    private var spikeNodes : [TileNode] = []
    
    init(scene : SCNScene, playerCube : PlayerCubeNode) {
        self.scene = scene
        self.playerCube = playerCube
        setUpInitialTileNodes()
    }
}

// MARK: - Add Tile Node
extension TileManager {
    func addNewTile(_ tileId : UUID?) {
        guard let firstTileNode = tileNodes.first else { return }
        removeTileNode(firstTileNode)
        removeSpikeNode()
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
        if !isInitialTile {
            // Never add a "spike" block option on the first level
            setUpNextTileCoordinates(tileNode)
        }
        
        let position = SCNVector3(tileCoordinates.xPosition,
                                  tileCoordinates.yPosition,
                                  tileCoordinates.zPosition)
        tileNode.updatePosition(position: position)
        
        // Add the spike node
        if !isInitialTile, Utils.randomBool(Constants.Gameplay.spikeTileOdds) {
            addSpikeNode(position: position, isInitialTile: isInitialTile, tilePosition: tileNode.tilePosition)
        }
    }
    
    private func setUpNextTileCoordinates(_ tileNode : TileNode) {
        // Set next Y position
        tileCoordinates.yPosition -= 2 // Next block should always be place below current block
        // Set next X position
        tileCoordinates.xPosition = tileNode.tilePosition == .right ?
        (tileCoordinates.xPosition + 4) : tileCoordinates.xPosition
        // Set next Z position
        tileCoordinates.zPosition = tileNode.tilePosition == .right ?
        tileCoordinates.zPosition : (tileCoordinates.zPosition + 4)
    }
}

// MARK: - Spike Node
private extension TileManager {
    private func addSpikeNode(position : SCNVector3,
                              isInitialTile : Bool,
                              tilePosition : TilePosition) {
        let spikeNodePosition : TilePosition = (tilePosition == .left) ? .right : .left
        let spikeNode = TileNode(tilePosition: spikeNodePosition,
                                 isFirstTile: isInitialTile,
                                 isSpikeNode: true)
        self.spikeNodes.append(spikeNode)
        self.setSpikeNodePosition(position: position, spikePosition: spikeNodePosition, spikeNode: spikeNode)
        Utils.addNodeToScene(scene, spikeNode)
    }
    
    private func setSpikeNodePosition(position : SCNVector3,
                                      spikePosition : TilePosition,
                                      spikeNode : TileNode) {
        let y = position.y
        let x = (spikePosition == .left) ? (position.x - 4) : (position.x + 4)
        let z = (spikePosition == .left) ? (position.z + 4) : (position.z - 4)
        spikeNode.updatePosition(position: SCNVector3(x, y, z))
    }
}

// MARK: - Remove nodes
private extension TileManager {
    func removeTileNode(_ tileNode : TileNode) {
        guard self.tileNodes.count > Constants.Node.maxNumberOfTiles else { return }
        tileNode.removeFromParentNode()
        tileNodes.removeFirst()
    }
    
    func removeSpikeNode() {
        guard let spikeNode = spikeNodes.first, spikeNodes.count > Constants.Node.maxNumberOfSpikeTiles else { return }
        spikeNode.removeFromParentNode()
        spikeNodes.removeFirst()
    }
    
    func removeDeadZoneNode(_ tileId : UUID?) {
        let contactedTile = tileNodes.first(where: { $0.id == tileId })
        guard let contactedTile else { return }
        contactedTile.removeDeadZone()
    }
}

// MARK: - Set up initial tile nodes
private extension TileManager {
    func setUpInitialTileNodes() {
        for i in Constants.Node.rangeOfInitialNodes {
            addTileNode((i == 0))
        }
    }
}

// MARK: - Restart Game
extension TileManager {
    func reset() {
        for tileNode in self.tileNodes {
            tileNode.removeFromParentNode()
        }
        for spikeNode in self.spikeNodes {
            spikeNode.removeFromParentNode()
        }
        self.tileNodes.removeAll()
        self.spikeNodes.removeAll()
        self.tileCoordinates = TileCoordinates()
        self.setUpInitialTileNodes()
    }
}

extension TileManager {
    func gameOver(timerEnded : Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            for tile in self.tileNodes {
                tile.gameOver()
                if timerEnded, Utils.isWithinOne(tile.position.y, (self.playerCube.position.y - 1)) {
                    tile.dropTile()
                }
            }
            
            for spikeNode in self.spikeNodes {
                spikeNode.gameOver()
            }
        }
    }
}

enum TilePosition : CaseIterable {
    case left, right
}
